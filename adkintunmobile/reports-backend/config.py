class ServerSettings:
    urls = {
    "server_url": "this-should-be-changed",
    "antenna_url" : "antenna",
    "report_url" : "reports",
    "ranking_url" : "reports",
    "network_url" : "reports",
    "signal_url" : "reports"
    }


class DefaultConfig(object):
    DEBUG = True
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = "this-should-be-changed"
    USER = "this-should-be-changed"
    SQLALCHEMY_DATABASE_URI = "postgresql://" + USER + ":" + SECRET_KEY + "@postgres/visualization"
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    CORS_DOMAIN = '*'

class AppTokens:
    tokens = {
        "server" : "this-should-be-changed"
    }


class AdminUser:
    first_name = "this-should-be-changed"
    last_name = "this-should-be-changed"
    login = "this-should-be-changed"
    email = "this-should-be-changed"
    password = "this-should-be-changed"


class Files:
    LOGS_FOLDER = "tmp"
    IMPORT_LOG_FILE = "import.log"
    MAIN_LOG_FILE = "adkintun-frontend-debug.log"
    STATIC_FILES_FOLDER = "app/static"
