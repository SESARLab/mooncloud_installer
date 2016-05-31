from testagent.services.WorkerService import WorkerService, WorkerServiceException
from tornado.options import options
from tornado.options import parse_command_line, parse_config_file
from testagent.options import DEFAULT_CONFIG_FILE
from testagent.subscription_options import DEFAULT_SUBSCRIPTION_FILE
from celery import Celery
import fileinput
parse_config_file(options.conf, final=False)
parse_config_file(options.subscription_conf, final=False)
app = Celery()
WorkerService().configure(app, options)
from testagent.tasks import start_certification
xml = ""
for line in fileinput.input():
    xml = xml + line
print xml
result = start_certification.delay(xml)
print(result.get())