// smb2_base.c
// cl smb2_base.c /link ws2_32.lib

#include <winsock2.h>
#include <stdint.h>
#include <stdio.h>

int main(int argc,char**argv){
    if(argc<2){printf("usage: %s <ip>\n",argv[0]);return 0;}
    WSADATA w;WSAStartup(0x202,&w);

    SOCKET s=socket(AF_INET,SOCK_STREAM,0);
    struct sockaddr_in a;
    a.sin_family=AF_INET;
    a.sin_port=htons(445);
    a.sin_addr.s_addr=inet_addr(argv[1]);
    if(connect(s,(void*)&a,sizeof(a))!=0){printf("nope\n");return 0;}

    
    unsigned char pkt[256]={
        0x00,0x00,0x00,0x4A,   // nbss len 0x4A
        0xFE,'S','M','B',      // smb2 proto
        0x40,0,0,0,0,0,         // hdr
        0,0,0,0,0,0,0,0,         // msgid, etc
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,         // 64 bytes header done
        0x24,0x00,              // structsize
        0x04,0x00,              // dialect count
        0x01,0x00,              // signing enabled (not required)
        0,0,                    // reserved
        0,0,0,0,                // capabilities
        // client guid 16 zeros (hacked together)
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        // ctx offset/count etc
        0,0,0,0,0,0,0,0,
        // dialects:
        0x02,0x02, // 2.0.2
        0x10,0x02, // 2.1
        0x00,0x03, // 3.0
        0x11,0x03  // 3.1.1
    };

    // send the thing
    send(s,(char*)pkt,0x4E,0);

    unsigned char r[512];
    int n=recv(s,(char*)r,sizeof(r),0);
    closesocket(s);
    if(n<80){printf("bad response\n");return 0;}

    if(r[4]!=0xFE||r[5]!='S'||r[6]!='M'||r[7]!='B'){printf("not smb2\n");return 0;}

    // this is all netexec cares about:
    unsigned char sm = r[4+64+2];
    unsigned char dm0 = r[4+64+4];
    unsigned char dm1 = r[4+64+5];
    unsigned short dia = dm0 | (dm1<<8);

    printf("dialect: 0x%04x\n", dia);
    printf("signing_enabled: %d\n", (sm & 0x01)!=0);
    printf("signing_required: %d\n", (sm & 0x02)!=0);

    return 0;
}