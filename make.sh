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
    git add $c
done

git config user.email "oda-bot@odahub.io"
git config user.name "ODA CI Bot"
git commit -a -m "updated submodules"

sed 's/git@/https:\/\//; s/.ch:/.ch\//' -i .gitmodules
