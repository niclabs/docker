
class Config(object):
    DEBUG = False
    TESTING = False
    SESSION_TYPE = 'memcached'
    SECRET_KEY = 'this-really-needs-to-be-changed'
    CSRF_ENABLED = True
    SQLALCHEMY_TRACK_MODIFICATIONS = True
    BCRYPT_ITER = 10


class ProductionConfig(Config):
    DB_PASS = "this-really-needs-to-be-changed"
    USER = "this-really-needs-to-be-changed"
    DB_NAME = "this-really-needs-to-be-changed"
    DB_HOST = "postgres"
    DATABASE_URI = "postgresql://" + USER + ":" + DB_PASS + "@" + DB_HOST + "/" + DB_NAME


class AdminUser(object):
    # ADMIN_LOGIN should be an email
    ADMIN_LOGIN = "this-really-needs@to-be.changed"
    ADMIN_PASSWORD = "this-really-needs-to-be-changed"
