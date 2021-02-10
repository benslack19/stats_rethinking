# This script is not meant to be run on its own. They are meant to help maintain
# tracking of packages and their versions in an envrironment. They should be placed
# in .git/hooks/.

# The first snippet is meant to update the yaml file if I added a new package to
# the environment using a pip install. This happens with a git push.

# The second file is meant to update the yaml file after a git pull.

#############################################################################################################
# Place the lines below in a new script here: .git/hooks/pre-push 
# Note: no suffix

#!/usr/bin/env zsh

# To make sure my environment is optimally updated in my git repo, I am using this script.
# I found it here:
# https://stackoverflow.com/questions/52038034/push-and-pull-my-conda-environment-using-git/56787188#56787188

# I left the original pre-push.sample file that comes with a git init command.

echo "\n==================== pre-push hook ===================="

ENV_NAME="stats_rethinking"                                            # Edited this line

# Export conda environment to yaml file
conda env export -n $ENV_NAME > environment.yml                        # Edited this line

# Check if new environment file is different from original 
git diff --exit-code --quiet environment.yml                           # Edited this line

# If new environment file is different, commit it
if [[ $? -eq 0 ]]; then
    echo "Conda environment not changed. No additional commit."
else
    echo "Conda environment changed. Commiting new environment.yml"
    git add environment.yml
    git commit -m "Updating conda environment"                         # Edited this line
    echo 'You need to push again to push additional "Updating conda environment" commit.'
    exit 1
fi

#############################################################################################################

# Place these lines here: .git/hooks/post-merge

#!/usr/bin/env zsh

echo "\n==================== post-merge hook ===================="

changed_files="$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD)"

check_run() {
    echo "$changed_files" | grep --quiet "$1" && eval "$2"
}

echo "Have to update the conda environment"
check_run environment.yml "conda env update --file environment.yml"



#############################################################################################################

# Key packages to install upon initial environment creation
# (others installed as needed)

jupyter-contrib-nbextensions==0.5.1
matplotlib==3.3.4
numpy==1.20.1
pandas==1.2.1
scipy==1.6.0
seaborn==0.11.1
watermark==2.1.0                 # to output system information
yapf==0.30.0                     # for code formatting
