@ECHO OFF

if "%MOODLE_DOCKER_DB%"=="" (
    ECHO Error: MOODLE_DOCKER_DB is not set
    EXIT /B 1
)

PUSHD %cd%
CD %~dp0..
SET BASEDIR=%cd%
POPD

SET COMPOSE_CONVERT_WINDOWS_PATHS=true

SET DOCKERCOMPOSE=docker-compose -f "%BASEDIR%\base.yml"

IF NOT "%MOODLE_DOCKER_DB%"=="pgsql" (
    SET DOCKERCOMPOSE=%DOCKERCOMPOSE% -f "%BASEDIR%\db.%MOODLE_DOCKER_DB%.yml"
)

IF NOT "%MOODLE_DOCKER_BROWSER%"=="" (
    IF NOT "%MOODLE_DOCKER_BROWSER%"=="firefox" (
        SET DOCKERCOMPOSE=%DOCKERCOMPOSE% -f "%BASEDIR%\selenium.%MOODLE_DOCKER_BROWSER%.yml"
    )
)

IF NOT "%MOODLE_DOCKER_PHPUNIT_EXTERNAL_SERVICES%"=="" (
    SET DOCKERCOMPOSE=%DOCKERCOMPOSE% -f "%BASEDIR%\phpunit-external-services.yml"
)

%DOCKERCOMPOSE% %*
