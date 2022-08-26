#!/bin/sh

set -e

if test "$#" -ne 1 ; then
  echo 'usage: fetch.sh <pkg>'
  exit 1
fi

opam_cache() {
  local chksum=$1

  hash_fun=$(echo "$chksum" | cut -d= -f 1)
  archive_hash=$(echo "$chksum" | cut -d= -f 2)
  first_two=${archive_hash:0:2}

  echo "https://opam.ocaml.org/cache/${hash_fun}/${first_two}/${archive_hash}"
}

checksum_aux() {
  local file=$1
  local bin=$2
  local hash=$3

  output=$("$bin" "$file")
  if ! test "$output" = "$hash  $file" ; then
    echo "The file '$file' didn't match its checksum. Please remove it."
    echo
  fi
}

checksum() {
  local file=$1
  local chksum=$2

  hash_fun=$(echo "$chksum" | cut -d= -f 1)
  archive_hash=$(echo "$chksum" | cut -d= -f 2)

  case "$hash_fun" in
  md5) checksum_aux "$file" "md5sum" "$archive_hash" ;;
  sha1) checksum_aux "$file" "sha1sum" "$archive_hash" ;;
  sha256) checksum_aux "$file" "sha256sum" "$archive_hash" ;;
  sha512) checksum_aux "$file" "sha512sum" "$archive_hash" ;;
  *) echo "Could not detect checksum type '${hash_fun}'"; exit 1 ;;
  esac
}

fetch() {
  local pkg=$1

  file=$(opam show -furl.src: "$pkg")
  file=$(echo "$file" | sed -e 's,.*/,,' -e 's/"$//')
  chksum=$(opam show -furl.checksum: "$pkg")
  chksum=$(echo "$chksum" | head -n 1 | sed -e 's/^"//' -e 's/"$//')
  url=$(opam_cache "$chksum")

  echo "Fetching ${pkg}..."
  curl -sLo "$file" "$url"
  checksum "$file" "$chksum"
}

pkg=$1

if echo "$pkg" | grep -qF . ; then
  fetch "${pkg}"
else
  for version in $(opam show -fall-versions "$pkg") ; do
    fetch "${pkg}.${version}"
  done
fi
