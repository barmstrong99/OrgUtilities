/**
 * Author: Brian Armstrong
 * Date: March 5th, 2019
 * Description: This method extends the Exception class.  This is needed to be able to throw an exception.
 **/
public with sharing class OrgException extends Exception {
    // Add logic for extending the Exception class.

    public string getSandboxName() {
        string sandboxName = UserInfo.getUserName().substringAfterLast('.');
        if (sandboxName == 'com')
            sandboxName = '';
        return sandboxName;
    }

    public string getOrgId() {
        return UserInfo.getOrganizationId();
    }
    
}