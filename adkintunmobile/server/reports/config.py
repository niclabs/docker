class DefaultConfig(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    BIND_KEY = "frontend"
    USER_SERVER = "this-should-be-changed"
    SECRET_KEY_SERVER = "this-should-be-changed"
    HOST_SERVER = "this-should-be-changed"
    DB_NAME_SERVER = "this-should-be-changed"
    USER_FRONTEND = "this-should-be-changed"
    SECRET_KEY_FRONTEND = "this-should-be-changed"
    HOST_FRONTEND = "this-should-be-changed"
    DB_NAME_FRONTEND = "this-should-be-changed"
    SQLALCHEMY_DATABASE_URI = "postgresql://{}:{}@{}/{}".format(USER_SERVER, SECRET_KEY_SERVER,
                                                                HOST_SERVER, DB_NAME_SERVER)
    SQLALCHEMY_BINDS = {
        BIND_KEY: "postgresql://{}:{}@{}/{}".format(USER_FRONTEND, SECRET_KEY_FRONTEND,
                                                    HOST_FRONTEND, DB_NAME_FRONTEND)
    }
    SQLALCHEMY_TRACK_MODIFICATIONS = True


class TestConfig(object):
    USER = "this-should-be-changed"
    SECRET_KEY = "this-should-be-changed"
    BIND_KEY = "frontend"
    SQLALCHEMY_DATABASE_URI = "postgresql://" + USER + ":" + SECRET_KEY + "@localhost/this-should-be-changed"
    SQLALCHEMY_BINDS = {
        BIND_KEY: "postgresql://" + USER + ":" + SECRET_KEY + "@localhost/this-should-be-changed"
    }
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    PRESERVE_CONTEXT_ON_EXCEPTION = False
    TESTING = True
    DEBUG = True


class Files:
    STATIC_FILES_FOLDER = "app/static"
    REPORTS_FOLDER = STATIC_FILES_FOLDER + "/" + "reports"
    LOGS_FOLDER = "tmp"
    REPORTS_LOG_FILE = "report.log"
