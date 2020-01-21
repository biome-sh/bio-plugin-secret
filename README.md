# Biome Plugin Git Source

This plugin adds `do_secret_copy` method which helps your deal with secret files

## Usage

1. Create `.secrets` directory in your repository or in the parent directory
2. Add `.secrets` to `.gitignore` if it lives in the repository
3. Put `SECRET_FILE` into `.secrets`
4. If you project has multiple packages you can prefix secret name with `pkg_name`: `$pkg_name-SECRET_FILE`

```
pkg_build_deps+=(biome/bio-plugin-secrets)

do_setup_environment() {
  source $(pkg_path_for biome/bio-plugin-secrets)/lib/plugin.sh

  # Will try to copy:
  # * .secrets/PKG_NAME-netrc
  # * .secrets/netrc
  do_secret_copy netrc ~/.netrc
  do_secret_copy npmrc ~/.npmrc
  do_secret_copy maven-settings.xml ~/.maven-settings.xml
}
```

Consider source [bio-plugin-secrets](habitat/lib/plugin.sh)
