set -x



echo """
machine gitlab.astro.unige.ch
login gitlab-ci-token
password ${CI_JOB_TOKEN}
""" >> $HOME/.netrc

chmod 400 $HOME/.netrc

for c in cdci_*; do
    (
        cd $c
        git remote set-url origin $(git remote get-url origin | sed 's/git@/https:\/\//; s/.ch:/.ch\//')
        git pull origin staging-1.3
    )
done

sed 's/git@/https:\/\//; s/.ch:/.ch\//' -i .gitmodules
