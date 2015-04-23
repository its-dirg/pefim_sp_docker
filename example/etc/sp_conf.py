# -*- coding: utf-8 -*-
import uuid
from saml2.entity_category.at_egov_pvp2 import PVP2
from saml2 import BINDING_HTTP_REDIRECT, BINDING_HTTP_POST
from saml2.cert import OpenSSLWrapper
from saml2.extension.idpdisc import BINDING_DISCO
from saml2.saml import NAME_FORMAT_URI, NAMEID_FORMAT_PERSISTENT
import service_conf

try:
    from saml2.sigver import get_xmlsec_binary
except ImportError:
    get_xmlsec_binary = None

if get_xmlsec_binary:
    xmlsec_path = get_xmlsec_binary(["/opt/local/bin"])
else:
    xmlsec_path = '/usr/bin/xmlsec1'

HOST = 'localhost'
PORT = service_conf.PORT

BASE = "https://%s:%s" % (HOST, PORT)

def generate_cert():
    sn = uuid.uuid4().urn
    cert_info = {
        "cn": "localhost",
        "country_code": "se",
        "state": "ac",
        "city": "Umea",
        "organization": "ITS",
        "organization_unit": "DIRG"
    }
    osw = OpenSSLWrapper()
    ca_cert_str = osw.read_str_from_file("root_cert/localhost.ca.crt")
    ca_key_str = osw.read_str_from_file("root_cert/localhost.ca.key")
    req_cert_str, req_key_str = osw.create_certificate(cert_info, request=True, sn=sn, key_length=2048)
    cert_str = osw.create_cert_signed_certificate(ca_cert_str, ca_key_str, req_cert_str)
    return cert_str, req_key_str

CONFIG = {
    "entityid": "%s/testsp.xml" % BASE,
    "description": "Test local SP",
    "entity_category": [PVP2],
    "generate_cert_func": generate_cert,
    "service": {
        "sp": {
            "authn_requests_signed": "true",
            "want_assertions_signed": "false",
            "want_response_signed": "true",
            "allow_unsolicited": "false",
            "name": "LocalTestSP",
            "endpoints": {
                "assertion_consumer_service": [
                    ("%s/acs/redirect" % BASE, BINDING_HTTP_REDIRECT),
                    ("%s/acs/post" % BASE, BINDING_HTTP_POST)
                ],
                "single_logout_service": [(BASE + "/slo", BINDING_HTTP_REDIRECT)],
                "discovery_response": [("%s/disco" % BASE, BINDING_DISCO)]
            },
            "required_attributes": ["pvp-version", "pvp-principal-name", ],
            "optional_attributes": ["pvp-givenname", "pvp-birthdate", "pvp-userid", ],
            "name_id_format": [NAMEID_FORMAT_PERSISTENT],
        },
    },
    "debug": 1,
    "key_file": "pki/mykey.pem",
    "cert_file": "pki/mycert.pem",
    "metadata": {
        "local": [
            "metadata/pefim_proxy_conf.xml"
        ],
    },


    # -- below used by make_metadata --
    "organization": {
        "name": "Test SP",
        "display_name": [("Test SP", "en")],
        "url": "http://localhost:%s" % PORT,
    },
    "contact_person": [
        {
            "contact_type": "technical",
            "given_name": "Test",
            "sur_name": "Testsson",
            "email_address": "test.testsson@test.com"
        },
    ],
    "xmlsec_binary": xmlsec_path,
    "name_form": NAME_FORMAT_URI,
    "logger": {
        "rotating": {
            "filename": "sp.log",
            "maxBytes": 100000,
            "backupCount": 5,
        },
        "loglevel": "debug",
    }
}

