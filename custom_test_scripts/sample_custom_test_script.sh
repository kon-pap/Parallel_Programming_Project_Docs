#!/bin/bash

# TODO@Students: Adjust these parameters to suit your needs
GROUP="group-302"
REPOSITORY="openmp"

echo "Now setting up your repository..."
PRIVATE_KEY_FILE="$(pwd)/.ssh/id_rsa"

# This is your repository access key. Don't share this or your repository will be accessible from the outside.
mkdir -p "$(pwd)/.ssh"
cat <<- EOF > "$PRIVATE_KEY_FILE"
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----

EOF

chmod 600 "$PRIVATE_KEY_FILE"

export GIT_SSH_COMMAND="ssh -i '$PRIVATE_KEY_FILE' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

echo "Cloning your repository..."
git clone "git@gitlab.lrz.de:lrr-tum/teaching/parprog/ss2021/project-material/${GROUP}/${REPOSITORY}.git" || exit 255

# Link the data directory. This is only needed for project 1.
if [ -e "${REPOSITORY}/data/" ]
then
  ln -s "$(pwd)/data/COAUTHORCS" "${REPOSITORY}/data/COAUTHORCS" || exit 255
fi

pushd "${REPOSITORY}" || exit 255

git config user.name "ParProg Submission Server"
git config user.email "noreply@parprog.caps.in.tum.de"

echo -e "\nNow running your tasks."
# You now have full access to your repository
# If you create large amounts of data, please remember to remove it to free up storage space from the submission server.

echo "The current directory is $(pwd). Directory listing:"
ls -la

# TODO@Students: Put your run commands here. Adjust these to make them work for your project.
make sequential
perf stat ./sequential

# TODO@Students If you need to, you can commit and push your changes/measurements by uncommenting the following lines:
# git add .
# git commit -m "ParProg Server Test"
# git push

popd || exit 255