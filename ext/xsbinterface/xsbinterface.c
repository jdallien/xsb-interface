/* XSBString interface thingie for gemming*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <xsb/cinterf.h>
#include <xsb/string_xsb.h>
// #include <xsb/xsbinterface.h>

int connect_xsb(char *);
void disconnect_xsb();
void free_result();

char *sResult;

/***********************************************************************
  int connect_xsb(char *sXSBPath) - This function must be called as the 
  first step of connecting to XSB. sXSBPath should be the path of the 
  XSB installation directory. Return value is the result of xsb_init. 
***********************************************************************/
int connect_xsb(char *sXSBPath) {
  int rcode;
  int myargc = 3;
  char *myargv[3];
  sResult = NULL;

  myargv[0] = sXSBPath;
  myargv[1] = "--quietload";
  myargv[2] = "-n";

  rcode = 0;
  rcode = xsb_init(myargc,myargv);    /* Initialize XSB */

  return rcode;
}

/************************************************************************
  disconnect_xsb() - This function closes the connection to XSB and frees the 
  query result string buffer. Do not use the string pointer after calling
  close_xsb.
************************************************************************/
void disconnect_xsb(void) {
  free(sResult);
  sResult = NULL;
  xsb_close();              /* XSB C interface close function */
}


/***********************************************************************
void free_result() - Manually free memory being used to store the 
previous result from an XSB query. This memory is automatically released 
when a new query result is being retrieved, or the connection to XSB is
closed.
***********************************************************************/
void free_result() {
  free(sResult);
  sResult = NULL;
}

/***********************************************************************
 int cmd_and_query_xsb(char *sCmd, char *sQuery, char *sResponse) - 
 This function runs the XSB command in sCmd which could be an assertion
 of a query. Then XSB is instructed to run sQuery, which returns a 
 string of the resulting variables. sResponse is a pointer to a string 
 which will hold the result until the next query is called, the XSB
 connection is closed, or free_result(). It is best to copy this string 
 to your own immediately. Return value is 0 if successful, 1 if sCmd 
 failed, 2 if sQuery failed. sResponse pointer is unchanged if either 
 one fails.
***********************************************************************/
int query_xsb(char *sQuery, char** sResponse) {
  int rcode;
  XSB_StrDefine(vsResult);
  xsb_close_query(); 

      rcode = xsb_query_string_string(sQuery, &vsResult, ";");

    if (rcode) 
      rcode = 2;
    else {
      // release any previously allocated memory for a result string
      free(sResult);

      // allocate sufficient space to hold VarString's contents, then copy
      // contents to string.
      sResult = malloc(vsResult.length+1); 
      if (vsResult.length > 0) {
        strcpy(sResult, vsResult.string);
        *sResponse = sResult;
      } else {
        rcode = 2;
      }
    }

  XSB_StrDestroy(&vsResult);

  /* make sure our own query is closed. */
   xsb_close_query();

return rcode;
}

int command_xsb(char *sCmd) {
    int rcode;

   xsb_close_query(); 
  rcode = xsb_command_string(sCmd);
   xsb_close_query();

return rcode;
}

int consult_p_file( char* p_file_name ) {
  char cd_command[256];
  int rcode;
  sprintf( cd_command, "consult(%s).", p_file_name);
  rcode = xsb_command_string(cd_command);
  return(rcode);
}



// this is the function called by constraint_solver.rb

void initialize_xsb_path(char * path) {
    strcpy( path, (char *) strip_names_from_path(xsb_executable_full_path("xsb"), _XSB_PATH_DEPTH) );
}

int initialize_xsb() {
  char path[256];
  int  rcode;
  initialize_xsb_path(path);
  rcode = connect_xsb( path );
  return rcode;
}

