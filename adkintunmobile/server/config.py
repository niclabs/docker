class DefaultConfig(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = "this-really-needs-to-be-changed"
    USER = "this-really-needs-to-be-changed"
    SQLALCHEMY_DATABASE_URI = "postgresql://" + USER + ":" + SECRET_KEY + "@postgres-adk/this-really-needs-to-be-changed"
    SQLALCHEMY_TRACK_MODIFICATIONS = True


class TestingConfig(DefaultConfig):
    SQLALCHEMY_DATABASE_URI = "postgresql://user_test:password_test@postgres-adk/adkintun_test"
    PRESERVE_CONTEXT_ON_EXCEPTION = False
    TESTING = True
    DEBUG = True


class AppTokens:
    tokens = {
        # random string, size 50 : name of the token
        "token-for-app-mobile": "app_mobile",
    }


class AdminUser:
    first_name = "this-really-needs-to-be-changed"
    last_name = "this-really-needs-to-be-changed"
    login = "this-really-needs-to-be-changed"
    email = "this-really-needs-to-be-changed"
    password = "this-really-needs-to-be-changed"


class OpenCellIdToken:
    """
    Open CellId Key token used in the antenna geolocalization process
    """
    token = "this-really-needs-to-be-changed"


class Urls:
    BASE_URL_OPENCELLID = "http://opencellid.org/cell/get"


class Files:
    LOGS_FOLDER = "tmp"
    GEOLOCALIZATION_LOG_FILE = "geolocalization.log"
    PRINCIPAL_LOG_FILE = "adkintun-debug.log"
    STATIC_FILES_FOLDER = "app/static"
    FILES_FOLDER = "speedtest_files"
    REPORTS_FOLDER = STATIC_FILES_FOLDER + "/" + "reports"
