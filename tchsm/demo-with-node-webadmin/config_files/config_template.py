class DefaultConfig(object):
    DEBUG = True
    CSRF_ENABLED = True
    SECRET_KEY = 'app secret key'
    SQLALCHEMY_DATABASE_URI = 'sqlite:////etc/node_n.db'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    NODE_PUBLIC_KEY = 'node public key'
    ADMIN_EMAIL = 'admin@mail.com'
    ADMIN_PASSWORD = 'secret-password'




