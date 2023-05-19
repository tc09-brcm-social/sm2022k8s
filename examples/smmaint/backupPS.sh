#!/bin/bash
cd ../../envs 
bash common/smmaint/bkupstore.sh \
    | bash common/smmaint/uses3.sh
