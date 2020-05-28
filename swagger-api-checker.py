#!/usr/bin/env python3
# coding: utf-8
# pylint: disable=C0103
# pylint: disable=C0301
# pylint: disable=C0411
# pylint: disable=C0413
# pylint: disable=W0611
# pylint: disable=W0612
# pylint: disable=W0702
# pylint: disable=W0703
# pylint: disable=W0621
# pylint: disable=R0913
"""
This script parses a Swagger schema definition file and counts the
number of available service calls and the number of unique parameters

Burp Suite Plugin
https://github.com/PortSwigger/swagger-parser

OpenAPI based web-services documentation
https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md
"""

import argparse
import json
import logging
import os
import requests
import sys


param_list = []

param_counter = 0
param_counter_fd = 0
param_counter_arr = 0
param_counter_bol = 0
param_counter_int = 0
param_counter_sch = 0
param_counter_str = 0
param_counter_unk = 0


def do_request(url, method="get", headers=None, params=None,
               data=None, cookies=None, proxy=None, verify=False):
    """
    Issue an HTTP request

    Args:
        url (string): target URL
        method (string): HTTP method (get or post; default=get)
        headers (dict): HTTP request headers
        params (dict): HTTP GET parameters
        data (dict): HTTP POST data
        cookies (class requests.cookies.RequestsCookieJar): HTTP cookies
        proxy (dict): HTTP proxy
        verify (bool): SSL verify
    Returns:
        class requests.Response: HTTP response
    """
    try:
        if method == "get":
            req = requests.get(url, headers=headers, params=params,
                               cookies=cookies, proxies=proxy, verify=verify)
        elif method == "post":
            req = requests.post(url, headers=headers, params=params, data=data,
                                cookies=cookies, proxies=proxy, verify=verify)
    except requests.ConnectionError:
        logging.error("Connection error")
    except requests.HTTPError:
        logging.error("Invalid HTTP response")
    except requests.Timeout:
        logging.error("Connection timeout")
    except requests.TooManyRedirects:
        logging.error("Too many redirects")
    else:
        logging.debug("Request URL: %s", url)
        logging.debug("Request data: %s", data)
        logging.debug("HTTP response: \n%s", req.text)
    try:
        if req.status_code != 200:
            logging.error("Failed to perfom request to %s", url)
            logging.debug("Error code: %s", req.status_code)
            logging.debug("Failed HTTP request: \n%s", req.text)
        else:
            logging.info("HTTP response OK (%s)", req.status_code)
    except Exception:
        logging.error("HTTP request failed: none returned")
        raise Exception("HTTP request failed: none returned")
    else:
        return req




if __name__ == '__main__':

    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description="Swagger scoping script",
        epilog="Example:\n\t{0} -f swagger.json"
        "\n\t{0} -u http://www.site.com/v2/swagger/docs/v1".format(__file__),
        add_help=True)

    parser.add_argument("-f", "--file", action="store", dest="file", required=False,
                        type=str, help="JSON schema file", default=None)
    parser.add_argument("-u", "--url", action="store", dest="url", required=False,
                        type=str, help="JSON schema URL", default=None)
    parser.add_argument("-l", "--loglevel", action="store", dest="level", required=False,
                        type=int, help="Log level (10,20,30,40,50)", default=50)

    args = parser.parse_args()

    logging.basicConfig(level=args.level)

    if args.file is None and args.url is None:
        print(parser.format_help())
        sys.exit(1)

    # logging.info("Starting")
    # logging.error("Exiting program")

    if args.url is not None and args.file is None:
        print("\033[0;32m[+]\033[0m Using URL {0}".format(args.url))
        try:
            req = do_request(args.url)
            json_obj = req.json()
        except Exception:
            raise Exception("Cannot load URL %s", args.url)
            #logging.error("Cannot load URL %s", args.url)
            #sys.exit(30)

    if args.file is not None and args.url is None:
        print ("\033[0;32m[+]\033[0m Using file {0}".format(args.file))
        try:
            json_fp = open(args.file, "r")
            json_str = json.load(json_fp, "utf-8") # json.load closes the fp
            json_obj = json.loads(json_str)
        except Exception:
            raise Exception("Cannot load file %s", args.file)
            #logging.error("Cannot load file %s", args.file)
            ##raise Exception("\033[0;31m[-]\033[0m Cannot open %s", args.file)
            #sys.exit(31)

    # try:
    #     json_obj = json.loads(json_str)
    # except:
    #     raise Exception("Cannot load JSON")
    #     # raise Exception("\033[0;31m[-]\033[0m Cannot load %s", args.file)
    # finally:
    #     print ("\n\033[0;32m[+]\033[0m"),
    #     print ("Loaded JSON data")
    #     print ("\033[0;32m[+]\033[0m\n"),

    for path_key, path_val in json_obj['paths'].items():
        #print ("\033[0;32m[+]\033[0m"),
        #print ("URL: {0}".format(path_key))
        print ("\033[0;32m[+]\033[0m URL: {0}".format(path_key))


        for http_verb, path_data in path_val.items():
            #print ("\033[0;32m[+]\033[0m\t"),
            #print ("Method: %s" % http_verb.upper())
            print ("\033[0;32m[+]\033[0m\t Method: %s" % http_verb.upper())

            # if "summary" in path_data.keys():
            #     path_sum = path_data["summary"]
            # if "operationId" in path_data.keys():
            #     path_operationId = path_data["operationId"]
            if "summary" in path_data.keys():
                #print ("\033[0;32m[+]\033[0m\t\t"),
                #print ("Summary: %s" % path_data["summary"])
                print ("\033[0;32m[+]\033[0m\t\t Summary: %s" % path_data["summary"])

            # ====================================================================
            #  Parameters
            # ====================================================================
            # json_obj['paths']['/Remessa']['post']['summary']
            # json_obj['paths']['/Remessa']['post']['operationId']
            # json_obj['paths']['/Remessa']['post']['parameters'][0]
            # json_obj['paths']['/Remessa']['post']['parameters'][0]['name']
            # json_obj['paths']['/Remessa']['post']['parameters'][0]['required']
            # json_obj['paths']['/Remessa']['post']['parameters'][0]['description']
            # json_obj['paths']['/Remessa']['post']['parameters'][0]['schema']['$ref']

            if "parameters" in path_data.keys():
                for param in path_data["parameters"]:
                    print ("\033[0;32m[+]\033[0m\t\t Parameter #%d:" % param_counter)
                    if "name" in param.keys() and param["name"]:
                        print ("\033[0;32m[+]\033[0m\t\t\t Name: %s" % param["name"])
                    if "tag" in param.keys() and param["tag"]:
                        print ("\033[0;32m[+]\033[0m\t\t\t Tag: %s" % param["tag"])
                    if "type" in param.keys():
                        print ("\033[0;32m[+]\033[0m\t\t\t Type: %s" % param["type"])
                        if "type" == "file":    param_counter_fd += 1
                        elif "type" == "array":   param_counter_arr += 1
                        elif "type" == "number":  param_counter_int += 1
                        elif "type" == "string":  param_counter_str += 1
                        elif "type" == "boolean": param_counter_bol += 1
                        elif "type" == "integer": param_counter_int += 1
                        else: param_counter_unk +=1
                    if "description" in param.keys() and param["description"]:
                        print ("\033[0;32m[+]\033[0m\t\t\t Desc: %s" % param["description"])
                    if "schema" in param.keys() and param["schema"]["$ref"]:
                        print ("\033[0;32m[+]\033[0m\t\t\t Schema: %s" % param["schema"]["$ref"])
                        schema_ref = param["schema"]["$ref"].strip("#")
                        schema_ref1 = param["schema"]["$ref"].strip("#").split("/")[1]
                        schema_ref2 = param["schema"]["$ref"].strip("#").split("/")[2]
                        print ("\033[0;32m[+]\033[0m\t\t\t Schema ref: %s" % schema_ref)
                        schema_ref_dict = json_obj[schema_ref1][schema_ref2]["properties"]
                        for schema_ref_k,schema_ref_v in schema_ref_dict.items():
                            schema_ref_param = schema_ref_k
                            print ("\033[0;32m[+]\033[0m\t\t\t\t Parameter: %s " % schema_ref_param)
                            if "type" in schema_ref_v.keys():
                                schema_ref_type = schema_ref_v['type']
                                print ("\033[0;32m[+]\033[0m\t\t\t\t Type: %s" % schema_ref_type)
                                if "type" == "file":    param_counter_fd += 1
                                elif "type" == "array":   param_counter_arr += 1
                                elif "type" == "number":  param_counter_int += 1
                                elif "type" == "string":  param_counter_str += 1
                                elif "type" == "boolean": param_counter_bol += 1
                                elif "type" == "integer": param_counter_int += 1
                                else: param_counter_unk +=1
                                param_counter_sch += 1
                            if "$ref" in schema_ref_v.keys():
                                # schema_ref  = schema_ref_v['$ref']
                                schema_ref  = schema_ref_v["$ref"].strip("#")
                                schema_ref1 = schema_ref_v["$ref"].strip("#").split("/")[1]
                                schema_ref2 = schema_ref_v["$ref"].strip("#").split("/")[2]
                                print ("\033[0;32m[+]\033[0m\t\t\t\t\t Schema ref: %s" % schema_ref)
                                schema_ref_dict = json_obj[schema_ref1][schema_ref2]["properties"]
                                for schema_ref_k,schema_ref_v in schema_ref_dict.items():
                                    schema_ref_param = schema_ref_k
                                    print ("\033[0;32m[+]\033[0m\t\t\t\t\t\t Parameter: %s " % schema_ref_param)
                                    if "type" in schema_ref_v.keys():
                                        schema_ref_type = schema_ref_v['type']
                                        print ("\033[0;32m[+]\033[0m\t\t\t\t\t\t Type: %s" % schema_ref_type)
                                        if "type" == "file":    param_counter_fd += 1
                                        elif "type" == "array":   param_counter_arr += 1
                                        elif "type" == "number":  param_counter_int += 1
                                        elif "type" == "string":  param_counter_str += 1
                                        elif "type" == "boolean": param_counter_bol += 1
                                        elif "type" == "integer": param_counter_int += 1
                                        else: param_counter_unk +=1
                                        param_counter_sch += 1
                                    param_counter += 1
                                    param_list.append(schema_ref_param)
                            param_counter += 1
                            param_list.append(schema_ref_param)
            param_counter = param_counter + 1
            param_list.append(schema_ref_param)


    # ====================================================================
    #  API Version
    # ====================================================================

    api_title = json_obj['info']['title']
    api_version = json_obj['info']['version']

    print ("\033[0;32m[+]\033[0m -----------------------------------------------")
    print ("\033[0;32m[+]\033[0m API Title: %s" % api_title)
    print ("\033[0;32m[+]\033[0m API Version: {0}".format(api_version))
    print ("\033[0;32m[+]\033[0m -----------------------------------------------")

    # ====================================================================
    #  Parameters
    # ====================================================================

    if param_counter_str: print ("\033[0;32m[+]\033[0m String parameters: %s" % param_counter_str)
    if param_counter_int: print ("\033[0;32m[+]\033[0m Number parameters: %s" % param_counter_int)
    if param_counter_bol: print ("\033[0;32m[+]\033[0m Boolean parameters: %s" % param_counter_bol)
    if param_counter_arr: print ("\033[0;32m[+]\033[0m Array parameters: %s" % param_counter_arr)
    if param_counter_fd:  print ("\033[0;32m[+]\033[0m File parameters: %s" % param_counter_fd)
    if param_counter_unk: print ("\033[0;32m[+]\033[0m Unknown type parameters: %s" % param_counter_unk)
    if param_counter_sch: print ("\033[0;32m[+]\033[0m Schema resolved parameters: %s" % param_counter_sch)
    print ("\033[0;32m[+]\033[0m -----------------------------------------------")

    # ====================================================================
    #  Paths (URLs)
    # ====================================================================

    api_paths = json_obj['paths']
    api_paths_str = json_obj['paths'].keys()
    print ("\033[0;32m[+]\033[0m Total discovered endpoints: %s" % len(api_paths))
    print ("\033[0;32m[+]\033[0m -----------------------------------------------")

    # ====================================================================
    #  Totals
    # ====================================================================

    #print ("\033[0;32m[+]\033[0m Total parameters: %s" % param_counter)
    print ("\033[0;32m[+]\033[0m Total parameters: %s" % len(param_list))
    print ("\033[0;32m[+]\033[0m Total unique parameters: %s" % len(list(set(param_list))))
    print ("\033[0;32m[+]\033[0m -----------------------------------------------\n")

    #print ("\033[0;32m[+]\033[0m Total unique definitions: {0}".format(len(json_obj['definitions'])))
    #for def_k,def_v in json_obj['definitions'].items():
    #    print ("\tDefinition: {0}".format(def_k))


    sys.exit(0)

# vim:ts=4 sts=4 tw=100:
