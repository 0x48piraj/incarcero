/**
 * Proxy
 * Copyright ©2008 Loki - All Rights Reserved
 **/

#pragma once

#define upnp_broadcast_ip   "239.255.255.250"
#define upnp_broadcast_port 1900
#define upnp_search_request "M-SEARCH * HTTP/1.1\r\n"       \
                            "Host:239.255.255.250:1900\r\n" \
                            "ST:upnp:rootdevice\r\n"        \
							"Man:\"ssdp:discover\"\r\n"     \
                            "MX:3\r\n"                      \
							"\r\n\r\n"
//#define upnp_device_type   "urn:schemas-upnp-org:device:WANConnectionDevice:1"
#define upnp_service_wanip "urn:schemas-upnp-org:service:WANIPConnection:1"
#define upnp_service_ppp   "urn:schemas-upnp-org:service:WANPPPConnection:1"
#define upnp_http_post "POST %s HTTP/1.1\r\n"                          \
                       "HOST: %s:%d\r\n"                               \
                       "CONTENT-LENGTH: %d\r\n"                        \
                       "CONTENT-TYPE: text/xml; charset=\"utf-8\"\r\n" \
                       "SOAPACTION:\"%s#AddPortMapping\"\r\n\r\n"      \
                       "%s"
#define upnp_soap_action "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n"     \
                         "<s:Envelope xmlns:s="                               \
                         "\"http://schemas.xmlsoap.org/soap/envelope/\" "     \
                         "s:encodingStyle="                                   \
                         "\"http://schemas.xmlsoap.org/soap/encoding/\">\r\n" \
                         "<s:Body>\r\n"                                       \
                         "<u:AddPortMapping xmlns:u=\"%s\">\r\n"              \
                         "%s"                                                 \
                         "</u:AddPortMapping>\r\n"                            \
                         "</s:Body>\r\n"                                      \
                         "</s:Envelope>\r\n"
#define upnp_add_port_mapping "<NewRemoteHost></NewRemoteHost>\r\n"                           \
                              "<NewExternalPort>%d</NewExternalPort>\r\n"                     \
                              "<NewProtocol>%s</NewProtocol>\r\n"                             \
                              "<NewInternalPort>%d</NewInternalPort>\r\n"                     \
                              "<NewInternalClient>%s</NewInternalClient>\r\n"                 \
                              "<NewEnabled>1</NewEnabled>\r\n"                                \
                              "<NewPortMappingDescription>%s</NewPortMappingDescription>\r\n" \
                              "<NewLeaseDuration>0</NewLeaseDuration>\r\n"


typedef struct _upnp_device_t
{
    char   Host    [16];
    ushort Port;
    char   Path    [512];
    char   Location[512];
    char   Control [512];
    char   Service [64];
} upnp_device_t;

BOOL upnp_discover ( upnp_device_t* Device, ushort Tries                                                     );
BOOL upnp_parse_url( upnp_device_t* Device                                                                   );
BOOL upnp_read_desc( upnp_device_t* Device                                                                   );
BOOL upnp_add_port ( upnp_device_t* Device, char* Protocol, char* Ip, ushort IPort, ushort EPort, char* Desc );