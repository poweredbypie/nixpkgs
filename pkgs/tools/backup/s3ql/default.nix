{ lib
, fetchFromGitHub
, python3
, sqlite
, which
}:

python3.pkgs.buildPythonApplication rec {
  pname = "s3ql";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "s3ql";
    repo = "s3ql";
    rev = "refs/tags/release-${version}";
    hash = "sha256-7N09b7JwMPliuyv2fEy1gQYaFCMSSvajOBPhNL3DQsg=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  nativeBuildInputs = [
    which
  ] ++ (with python3.pkgs; [
    cython
  ]);

  propagatedBuildInputs = with python3.pkgs; [
    apsw
    cryptography
    defusedxml
    dugong
    google-auth
    google-auth-oauthlib
    pyfuse3
    requests
    sqlite
    trio
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-trio
    pytestCheckHook
  ];

  preBuild = ''
    ${python3.pkgs.python.pythonOnBuildForHost.interpreter} ./setup.py build_cython build_ext --inplace
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [
    "s3ql"
  ];

  pytestFlagsArray = [
    "tests/"
  ];

  meta = with lib; {
    description = "A full-featured file system for online data storage";
    homepage = "https://github.com/s3ql/s3ql/";
    changelog = "https://github.com/s3ql/s3ql/releases/tag/s3ql-${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rushmorem ];
    platforms = platforms.linux;
  };
}
