#!/usr/local/bin/bash
# echoerr() { echo "LOG $@" 1>&2; }
echoerr() { printf "LOG %s\n" "$*" >&2; }

print_usage() { echoerr 'Usage: synthdata_batch [max_corr_steps tol_eps]'; exit 2; }

echoerr number of args $#
case $# in
  2) max_corr_steps=$1 epsilon=$2  # defaults: 3, 0.000001 try: {4,5,6,7} and 
  ;;
  1)  case $1 in
          -h | --help) 
            echo 'Usage: synthdata_batch [max_corr_steps tol_eps]' 1>&2; exit 2 
          ;;
      esac
  ;;
  0) echoer using default minus args
  ;;
  *) print_usage
esac

set -x
stamp=100_triplets
triplet_file=100-configurations-synthdata 
#stamp=tiny
#triplet_file=tiny-configurations-synthdata #100-configurations-synthdata 

# used inside minus-chicago-synth
if [ ! -z "$max_corr_steps" ]; then
  export minus_args="--epsilon $epsilon --max_corr_steps $max_corr_steps"
  stamp=$stamp-max_corr_steps_$max_corr_steps-epsilon_$epsilon
fi
eval_dir=$HOME/cprg/vxlprg/lemsvpe/minus/scripts/results-synth/work-$stamp

echoerr started sequential batch minus tester

if [ ! -d $eval_dir ]; then
  echoerr creating directory $eval_dir
  if ! mkdir $eval_dir; then
    echoerr synthdata_batch: could not create directory $eval_dir.
    exit 1
  fi
  # if it exists, we keep dumping files at it, differentiated by PID
#else
#  echo cleaning up $eval_dir
#  rm -f $eval_dir/*
fi

cp $0 $eval_dir/script.$$

while IFS= read -r sample_id || [ -n "$sample_id" ]
do
  sample_id_tr=`echo $sample_id |tr \  -`
  #mstdout=$eval_dir/${sample_id_tr}-$stamp-minus-synth-batch-stdout.$$;
  mstdout=/dev/null
  mstderr=$eval_dir/${sample_id_tr}-$stamp-minus-synth-batch-stderr.$$;
  minus-chicago-synth $sample_id 1>$mstdout 2>$mstderr
  solver_fail="$?"
  failfile=$eval_dir/${sample_id_tr}-$stamp-fail.$$;
  echo $solver_fail > $failfile
  tfile=$eval_dir/${sample_id_tr}-$stamp-time.$$;
  grep 'Time of solver' $mstderr |grep -o '[0-9][0-9]*ms'|grep -o '[0-9][0-9]*' > $tfile
done < $triplet_file
