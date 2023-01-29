#!/usr/bin/env bash

set -x
set -e
set -u

for host in master-1 master-2 loadbalancer worker-1 worker-2; do
    rsync -a quick-steps $host: &
    rsync -a cache/ $host: &
done
wait

set +e

# bash -x quick-steps/03a-master-1.sh
bash -x quick-steps/03b-master-1.sh
bash -x quick-steps/04a-master-1.sh </dev/null
bash -x quick-steps/05a-master-1.sh </dev/null
bash -x quick-steps/06a-master-1.sh
bash -x quick-steps/07a-master-1-master2.sh
ssh master-2 bash -x quick-steps/07a-master-1-master2.sh
bash -x quick-steps/08a-master-1-master2.sh </dev/null
ssh master-2 bash -x quick-steps/08a-master-1-master2.sh
ssh loadbalancer bash -x quick-steps/08b-loadbalancer.sh
ssh worker-1 bash -x quick-steps/09a-worker-1-worker-2.sh
ssh worker-2 bash -x quick-steps/09a-worker-1-worker-2.sh
bash -x quick-steps/10a-master-1.sh
ssh -T worker-1 <<EOF
    bash -x quick-steps/10b-worker-1.sh </dev/null
EOF
bash -x quick-steps/10c-master-1.sh
bash -x quick-steps/11a-master-1.sh
ssh -T worker-2 <<EOF
    bash -x quick-steps/11b-worker-2.sh </dev/null
EOF
bash -x quick-steps/11c-master-1.sh
bash -x quick-steps/12a-master-1.sh
bash -x quick-steps/13a-master-1.sh
bash -x quick-steps/14a-master-1.sh
bash -x quick-steps/15a-master-1.sh
bash -x quick-steps/16a-master-1.sh