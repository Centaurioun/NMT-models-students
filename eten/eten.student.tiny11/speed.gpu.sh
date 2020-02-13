#!/bin/bash

MARIAN=../../marian-dev/build

SRC=et
TRG=en

mkdir -p speed

sacrebleu -t wmt18 -l $SRC-$TRG --echo src > speed/newstest2018.$SRC

echo "### Translating wmt18 $SRC-$TRG on GPU"
$MARIAN/marian-decoder -c config.yml --skip-cost $@ \
    --quiet --quiet-translation --log speed/gpu.newstest2018.log \
    -i speed/newstest2018.$SRC -o speed/gpu.newstest2018.$TRG

tail -n1 speed/gpu.newstest2018.log
sacrebleu -t wmt18 -l $SRC-$TRG < speed/gpu.newstest2018.$TRG | tee speed/gpu.newstest2018.$TRG.bleu
