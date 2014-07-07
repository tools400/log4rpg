      /IF NOT DEFINED(PLOG4SOCK)
      /DEFINE PLOG4SOCK
      *
      /COPY QLOG4RPG,FDQJOB
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
     D socket_fd_t...
     D                 S             10I 0                     based(pDummy)
     D socket_fdSet_t...
     D                 S             28A                       based(pDummy)
      *
      * -----------------------------------------
      *  RPG implementations of C macros
      * -----------------------------------------
      *
      *  Set bit in file descriptor set.
     D FD_SET...
     D                 PR
     D                                     extproc('LOG4SOCK+
     D                                     _FD_SET+
     D                                     ')
     D i_FD                                const  like(socket_fd_t   )
     D io_FDSet                                   like(socket_fdSet_t)
      *
      *  Clear bit in file descriptor set.
     D FD_CLR...
     D                 PR
     D                                     extproc('LOG4SOCK+
     D                                     _FD_CLR+
     D                                     ')
     D i_FD                                const  like(socket_fd_t   )
     D io_FDSet                                   like(socket_fdSet_t)
      *
      *  Test bit in file descriptor set.
     D FD_ISSET...
     D                 PR              N
     D                                     extproc('LOG4SOCK+
     D                                     _FD_ISSET+
     D                                     ')
     D i_FD                                value  like(socket_fd_t   )
     D i_FDSet                             value  like(socket_fdSet_t)
      *
      *  Initialize file descriptor set with x'00'.
     D FD_ZERO...
     D                 PR
     D                                     extproc('LOG4SOCK+
     D                                     _FD_ZERO+
     D                                     ')
     D io_FDSet                                   like(socket_fdSet_t)
      *
      *  Returns the IP address of the 5250 client of the
      *  specified job.
     D Job_getTcpIpAddr...
     D                 PR            15A          varying
     D                                     extproc('LOG4SOCK+
     D                                     _Job_getTcpIpAddr+
     D                                     ')
     D  i_qJob                             const  likeds(qJob_t   )
     D                                            options(*nopass)
      *
      * -----------------------------------------
      *  Constants:
      * -----------------------------------------
      *
      *  Error code
     D SOCKET_ERROR    C                   const(-1)
      *
      *  Socket NULL
     D SOCKET_NULL     C                   const(-2)
      *
      * -----------------------------------------
      *  Constants:   QSYSINC/NETINET.IN
      * -----------------------------------------
      *
      *  Macros to denote protocols
     D IPPROTO_IP      C                   const(0)
     D IPPROTO_ICMP    C                   const(1)
     D IPPROTO_TCP     C                   const(6)
     D IPPROTO_UDP     C                   const(17)
     D IPPROTO_IPV6    C                   const(41)
     D IPPROTO_ROUTING...
     D                 C                   const(43)
     D IPPROTO_FRAGMENT...
     D                 C                   const(44)
     D IPPROTO_RAW     C                   const(255)
     D IPPROTO_ICMPV6  C                   const(58)
     D IPPROTO_NONE    C                   const(59)
     D IPPROTO_MAX     C                   const(256)
      *
      *  Macros for IP level options (via setsockopt() and getsockopt())
     D IP_OPTIONS      C                   const( 5)
     D IP_TOS          C                   const(10)
     D IP_TTL          C                   const(15)
      *
     D IP_MULTICAST_IF...
     D                 C                   const(20)
     D IP_MULTICAST_TTL...
     D                 C                   const(25)
     D IP_MULTICAST_LOOP...
     D                 C                   const(30)
     D IP_ADD_MEMBERSHIP...
     D                 C                   const(35)
     D IP_DROP_MEMBERSHIP...
     D                 C                   const(40)
     D IP_DONTFRAG...
     D                 C                   const(55)
     D IP_RECVLCLIFADDR...
     D                 C                   const(99)
      *
      *  Macros for Internet address specifications
     D INADDR_ANY...
     D                 C                   const(x'00000000')
     D INADDR_BROADCAST...
     D                 C                   const(x'FFFFFFFF')
     D INADDR_LOOPBACK...
     D                 C                   const(x'7F000001')
     D INADDR_NONE...
     D                 C                   const(x'FFFFFFFF')
      *
     D INADDR_UNSPEC_GROUP...
     D                 C                   const(x'E0000000')                   224.0.0.0
     D INADDR_ALLHOSTS_GROUP...
     D                 C                   const(x'E0000001')                   224.0.0.1
     D INADDR_MAX_LOCAL_GROUP...
     D                 C                   const(x'E00000FF')                   224.0.0.255
      *
     D INET_ADDRSTRLEN...
     D                 C                   const(16)
     D INET6_ADDRSTRLEN...
     D                 C                   const(46)
      *
      *  Macros for port numbers
     D IPPORT_RESERVED...
     D                 C                   const(1024)
      *
      *  Macros defining multicast operation
     D IP_DEFAULT_MULTICAST_TTL...
     D                 C                   const(1)
     D IP_DEFAULT_MULTICAST_LOOP...
     D                 C                   const(1)
     D IP_MAX_MEMBERSHIPS...
     D                 C                   const(20)
      *
      * -----------------------------------------
      *  Constants:   QSYSINC/SYS.SOCKET
      * -----------------------------------------
      *
      *  Macros to denote address families
     D AF_UNSPEC       C                   const( 0)
     D AF_UNIX         C                   const( 1)
     D AF_INET         C                   const( 2)
     D AF_NS           C                   const( 6)
     D AF_INET6        C                   const(24)
     D AF_UNIX_CCSID   C                   const(98)
     D AF_TELEPHONY    C                   const(99)
      *
      *  Macros to denote type of socket
     D SOCK_STREAM     C                   const(1)
     D SOCK_DGRAM      C                   const(2)
     D SOCK_RAW        C                   const(3)
     D SOCK_SEQPACKET  C                   const(5)
      *
      *  Macros for socket level options (via setsockopt() & getsockopt())
     D SO_BROADCAST    C                   const( 5)
     D SO_DEBUG        C                   const(10)
     D SO_DONTROUTE    C                   const(15)
     D SO_ERROR        C                   const(20)
     D SO_KEEPALIVE    C                   const(25)
      *
     D SO_LINGER       C                   const(30)
     D SO_OOBINLINE    C                   const(35)
      *
     D SO_RCVBUF       C                   const(40)
     D SO_RCVLOWAT     C                   const(45)
     D SO_RCVTIMEO     C                   const(50)
     D SO_REUSEADDR    C                   const(55)
     D SO_SNDBUF       C                   const(60)
     D SO_SNDLOWAT     C                   const(65)
     D SO_SNDTIMEO     C                   const(70)
     D SO_TYPE         C                   const(75)
     D SO_USELOOPBACK  C                   const(80)
      *
      *  Macros to be used for the flag parameter of input/output routines
     D MSG_DONTROUTE   C                   const(x'0001')
     D MSG_OOB         C                   const(x'0004')
     D MSG_PEEK        C                   const(x'0008')
     D MSG_TRUNC       C                   const(x'0010')
     D MSG_CTRUNC      C                   const(x'0020')
     D MSG_WAITALL     C                   const(x'0040')
     D MSG_EOR         C                   const(x'0080')
      *
      *  Miscellaneous macros
     D MSG_MAXIOVLEN   C                   const(16)
     D SOL_SOCKET      C                   const(-1)
     D SOMAXCONN       C                   const(512)
      *
      *  Macros to be used for the flag parameter on send_file()
     D SF_CLOSE        C                   const(1)
     D SF_REUSE        C                   const(2)
      *
      *  Macros to be used for the how parameter on shutdown()
     D SHUT_RD         C                   const(0)
     D SHUT_WR         C                   const(1)
     D SHUT_RDWR       C                   const(2)
      *
      *  Structures
     D linger...
     D                 DS                  qualified               based(pDummy)
     D  l_onoff                      10I 0
     D  l_linger                     10I 0
      *
      *  Generic socket address
     D sockaddr_t...
     D                 DS                  qualified               based(pDummy)
     D   sa_family                    5U 0
     D   sa_data                     14A
      *
      *  Internet socket address
     D sockaddr_in_t...
     D                 DS                  qualified               based(pDummy)
     D   sin_family                   5U 0
     D   sin_port                     5U 0
     D   sin_addr                    10U 0
     D   sin_zero                     8A
      *
      * -----------------------------------------
      *  Constants:   QSYSINC/H.FCNTL
      * -----------------------------------------
      *
      *  cmd Values for fcntl()
     D F_DUPFD         C                   const(0)
     D F_GETFD         C                   const(1)
     D F_SETFD         C                   const(2)
     D F_GETLK         C                   const(3)
     D F_SETLK         C                   const(4)
     D F_SETLKW        C                   const(5)
     D F_GETFL         C                   const(6)
     D F_SETFL         C                   const(7)
     D F_GETOWN        C                   const(8)
     D F_SETOWN        C                   const(9)
      *
      *  File Status Flags for open() and fcntl()
     D O_NONBLOCK      C                   const(128)
     D O_NDELAY        C                   const(128)
     D FNDELAY         C                   const(128)
     D FASYNC          C                   const(512)
      *
      * -----------------------------------------
      *  Constants:   QSYSINC/SYS.TIME
      * -----------------------------------------
      *
     D timeval_t...
     D                 DS                  qualified               based(pDummy)
     D   tv_sec                      10I 0
     D   tv_usec                     10I 0
      *
      * -----------------------------------------
      *  Socket Functions
      * -----------------------------------------
      *
      * -----------------------------------------------------------------------
      *  accept()--Wait for Connection Request and Make Connection
      *    -1     (unsuccessful)
      *     n     (successful), where n is a socket descriptor.
      *
      *  The accept() function is used to wait for connection requests.
      *  accept() takes the first connection request on the queue of
      *  pending connection requests and creates a new socket to service
      *  the connection request.
      * -----------------------------------------------------------------------
     D accept...
     D                 PR            10I 0 extproc('accept')
     D  i_sockDesc                   10I 0 value
     D  o_pAddress                     *   value
     D  io_pAddrLen                  10I 0
      *
      * -----------------------------------------------------------------------
      *  bind()--Set Local Address for Socket
      *    -1     (unsuccessful)
      *     0     (successful)
      *
      *  The bind() function is used to associate a local address with a
      *  socket.
      * -----------------------------------------------------------------------
     D bind...
     D                 PR            10I 0 extproc('bind')
     D  i_sockDesc                   10I 0 value
     D  i_pAddress                     *   value
     D  i_AddressLen                 10I 0 value
      *
      * -----------------------------------------------------------------------
      *  close()--Close File or Socket Descriptor
      *     0      close() was successful.
      *    -1      close() was not successful.
      *            The errno global variable is set to indicate the error.
      *
      *  The close() function closes a descriptor, fildes. This frees the
      *  descriptor to be returned by future open() calls and other calls
      *  that create descriptors.
      * -----------------------------------------------------------------------
      /IF NOT DEFINED(c_close_function)
      /DEFINE c_close_function
     D close...
     D                 PR            10I 0 extproc('close')
     D  i_fd                         10I 0 value
      /ENDIF
      *
      * -----------------------------------------------------------------------
      *  connect()--Establish Connection or Destination Address
      *    -1      (unsuccessful)
      *     0      (successful)
      *
      *  The connect() function is used to establish a connection on a
      *  connection-oriented socket or establish the destination address
      *  on a connectionless socket.
      * -----------------------------------------------------------------------
     D connect...
     D                 PR            10I 0 extproc('connect')
     D  i_fd                         10I 0 value
     D  i_pAddress                     *   value
     D  i_AddressLen                 10I 0 value
      *
      * -----------------------------------------------------------------------
      *  fcntl()--Perform File Control Command
      *    value  fcntl() was successful.
      *           The value returned depends on the command that was specified.
      *    -1     fcntl() was not successful.
      *           The errno global variable is set to indicate the error.
      *
      *  The fcntl() function performs various actions on open
      *  descriptors, such as obtaining or changing the attributes of a
      *  file or socket descriptor.
      * -----------------------------------------------------------------------
     D fcntl...
     D                 PR            10I 0 extproc('fcntl')
     D  i_fd                         10I 0 value
     D  i_command                    10I 0 value
     D  i_arg                        10I 0 value options(*nopass)
      *
      * -----------------------------------------------------------------------
      *  listen()--Invite Incoming Connections Requests
      *    -1     (unsuccessful)
      *     0     (successful)
      *
      *  The listen() function is used to indicate a willingness to accept
      *  incoming connection requests. If a listen() is not done, incoming
      *  connections are silently discarded.
      * -----------------------------------------------------------------------
     D listen...
     D                 PR            10I 0 extproc('listen')
     D  i_socketDesc                 10I 0 value
     D  i_BackLog                    10I 0 value
      *
      * -----------------------------------------------------------------------
      *  select()--Wait for Events on Multiple Sockets
      *    -1     (unsuccessful)
      *     0     (if the time limit expires)
      *     n     (total number of descriptors in all sets that met selection criteria)
      *
      *  The select() function is used to enable an application to
      *  multiplex I/O. By using select(), an application with multiple
      *  interactive I/O sources avoids blocking on one I/O stream while
      *  the other stream is ready. Thus, for example, an application that
      *  receives inputs from two distinct communication endpoints (using
      *  sockets) can use select() to sleep until input is available from
      *  either of the sources. When input is available, the application
      *  wakes up and receives an indication as to which descriptor is
      *  ready for reading.
      *
      *  The application identifies descriptors to be checked for read,
      *  write, and exception status and specifies a timeout value. If any
      *  of the specified descriptors is ready for the specified event
      *  (read, write, or exception), select() returns, indicating which
      *  descriptors are ready. Otherwise, the process waits until one of
      *  the specified events occur or the wait times out.
      * -----------------------------------------------------------------------
     D select...
     D                 PR            10I 0 extproc('select')
     D  i_maxDesc                    10I 0 value
     D  io_readSet                     *   value
     D  io_writeSet                    *   value
     D  io_excpSet                     *   value
     D  i_waitTime                     *   value
      *
      * -----------------------------------------------------------------------
      *  send()--Send Data
      *    -1     (unsuccessful)
      *     n     (successful), where n is the number of bytes sent.
      *
      *  The send() function is used to send data through a connected
      *  socket.
      * -----------------------------------------------------------------------
     D send...
     D                 PR            10I 0 extproc('send')
     D  i_socketDesc                 10I 0 value
     D  i_pBuffer                      *   value  options(*string)
     D  i_length                     10I 0 value
     D  i_flags                      10I 0 value
      *
      * -----------------------------------------------------------------------
      *  setsockopt()--Set Socket Options
      *    -1     (unsuccessful)
      *     0     (successful)
      *
      *  The setsockopt() function is used to set socket options.
      * -----------------------------------------------------------------------
     D setsockopt...
     D                 PR            10I 0 extproc('setsockopt')
     D  i_socketDesc                 10I 0 value
     D  i_optLevel                   10I 0 value
     D  i_optName                    10I 0 value
     D  i_optValue                     *   value
     D  i_optLen                     10I 0 value
      *
      * -----------------------------------------------------------------------
      *  getsockopt()--Retrieve Information about Socket Options
      *    -1     (unsuccessful)
      *     0     (successful)
      *
      *  The setsockopt() function is used to set socket options.
      * -----------------------------------------------------------------------
     D getsockopt...
     D                 PR            10I 0 extproc('getsockopt')
     D  i_socketDesc                 10I 0 value
     D  i_optLevel                   10I 0 value
     D  i_optName                    10I 0 value
     D  o_optValue                     *   value
     D  io_optLen                    10I 0
      *
      * -----------------------------------------------------------------------
      *  socket()--Create Socket
      *    -1     (unsuccessful)
      *     n     (successful), where n is a socket descriptor.
      *
      *  The socket() function is used to create an end point for
      *  communications. The end point is represented by the socket
      *  descriptor returned by the socket() function.
      * -----------------------------------------------------------------------
     D socket...
     D                 PR            10I 0 extproc('socket')
     D  i_addrFamily                 10I 0 value
     D  i_socketType                 10I 0 value
     D  i_protocol                   10I 0 value
      *
      * -----------------------------------------------------------------------
      *  gethostbyname()--Get Host Information for Host Name
      *    NULL   (unsuccessful)
      *       p   (successful), where p is a pointer to struct hostent.
      *
      *  The gethostbyname() function is used to retrieve information about a host.
      * -----------------------------------------------------------------------
     D gethostbyname...
     D                 PR              *   extproc('gethostbyname')
     D  i_hostName                     *   value options(*string)
      *
     D hostent_t...
     D                 DS                  qualified               based(pDummy)
     D   h_name                        *
     D   h_aliases                     *
     D   h_addrtype                   5I 0
     D   h_length                     5I 0
     D   h_addrlist                    *
      *
      * -----------------------------------------------------------------------
      *  inet_addr()--Translate Full Address to 32-bit IP Address
      *      -1   (unsuccessful)
      *       n   (where n is the 32-bit IP address)
      *
      *  The inet_addr() function is used to translate an Internet address
      *  from dotted decimal format to a 32-bit IP address.
      * -----------------------------------------------------------------------
     D inet_addr...
     D                 PR            10U 0 extproc('inet_addr')
     D  i_charAddr                     *   value options(*string)
      *
      /ENDIF
