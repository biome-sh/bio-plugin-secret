# shellcheck shell=bash

# Bio Plugin Secrets
# Adds `do_secret_copy` method which find `.secrets` directory and try secrets by `PKG_NAME-SECRET_NAME` or `SECRET_NAME`
# Example: `do_secret_copy netrc ~/.netrc`
#
# Variables:
# `pkg_secret_path` - specify alternate path to the `.secrets` directory
#
# Functions:
# `do_secret_copy` - copies secret from `.secrets` directory to destanation


if [[ -n "$pkg_secret_path" ]] && ! [[ -d "$pkg_secret_path" ]]; then
    exit_with "Secret directory was not found at $pkg_secret_path" 1
elif [[ -d ".secrets" ]]; then
    pkg_secret_path=".secrets"
elif [[ -d "../.secrets" ]]; then
    pkg_secret_path="../.secrets"
elif [[ -d "../../.secrets" ]]; then
    pkg_secret_path="../../.secrets"
elif [[ -d "../../../.secrets" ]]; then
    pkg_secret_path="../../../.secrets"
elif [[ -d "../../../../.secrets" ]]; then
    pkg_secret_path="../../../../.secrets"
else
    exit_with "You have loaded bio-plugin-secret, but '.secrets' directory was not found." 1
fi

build_line "Found secrets at $pkg_secret_path"

do_secret_copy() {
    local secret="$1"
    local dest="$2"

    # shellcheck disable=SC2154
    if [[ -f "$pkg_secret_path/$pkg_name-$secret" ]]; then
        secret="$pkg_secret_path/$pkg_name-$secret"
    elif [[ -f "$pkg_secret_path/$secret" ]]; then
        secret="$pkg_secret_path/$secret"
    else
        exit_with "Secret $pkg_name-$secret or $secret was not found"
        return 1
    fi

    if [[ -z "$dest" ]]; then
        exit_with "You must specify destination file"
        return 1
    fi

    build_line "Copying secret $secret -> $dest"
    cp "$secret" "$dest"
}
