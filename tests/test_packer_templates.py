import glob
import json
import os
import re
import unittest

from jinja2 import Environment, FileSystemLoader

from incarcero.incarcero import load_config

class PackerTemplateTestCase(unittest.TestCase):

    def setUp(self):
        self.env = Environment(loader=FileSystemLoader('incarcero/templates/'),
                               autoescape=False)

    def test_packer_template_rendering(self):
        for profile in glob.glob("incarcero/templates/*.json"):
            print("Processing file {}".format(profile))

            # process profile
            profile_name = os.path.basename(profile)
            config = load_config(open('incarcero/config-example.js', 'r'),
                                 re.match('(.*).json$', profile_name).group(1))

            try:
                template = self.env.get_template(os.path.basename(profile_name))
                profile_json = template.render(config) # pylint: disable=no-member
                print("Properly formatted Jinja2 template")
            except:
                print("Badly formatted Jinja2 template! Failing test...")
                raise()

            # test if json is valid
            try:
                json.loads(profile_json)
                print("Properly formatted JSON file")
            except:
                print("Badly formatted JSON file! Failing test...")
                raise()

if __name__ == '__main__':
        unittest.main()
