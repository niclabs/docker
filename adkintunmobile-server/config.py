class DefaultConfig(object):
    DEBUG = False
    TESTING = False
    CSRF_ENABLED = True
    SECRET_KEY = "this-really-needs-to-be-changed"
    USER = "this-really-needs-to-be-changed"
    SQLALCHEMY_DATABASE_URI = "postgresql://" + USER + ":" + SECRET_KEY + "@localhost/this-really-needs-to-be-changed"
    SQLALCHEMY_TRACK_MODIFICATIONS = True


class TestingConfig(DefaultConfig):
    SQLALCHEMY_DATABASE_URI = "postgresql://user_test:password_test@localhost/adkintun_test"
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
