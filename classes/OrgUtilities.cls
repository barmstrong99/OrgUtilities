/*
* Description: This class contains methods that are commonly used by the apex classes.
*/
public class OrgUtilities

    /* SalesForce Organizations */
    public static final String PRODUCTION_ORGANIZATION = 'Production';

    /* Email Address Lists */
    public static final String EXCEPTION_SUBJECT = 'Apex code has thrown an exception';
    public static final String ERROR_SUBJECT = 'Apex code has encountered an error';
    public static final List <String> EXCEPTION_EMAIL_ADDRESSES = new List<String>{'some.user@company.com'};  //  Used for sending exception emails.
    public static final List <String> ERROR_EMAIL_ADDRESSES = new List<String>{'some.user@company.com'};   // Used for sending error emails.
    public static final List <String> STATUS_EMAIL_ADDRESSES = new List<String>{'some.user@company.com'};  // Used for sending status update emails.

    // Query the salesforce organization record.
    private static Organization org = [Select Id, Name, InstanceName, IsSandbox, IsReadOnly, DefaultLocaleSidKey, TimeZoneSidKey from Organization limit 1];

    /**
     * Author: Brian Armstrong
     * Date: August 20th, 2021
     * Description: This method returns a true value if the organization is Production.
     **/
    public static boolean isProduction()
    {
        // Query the organization to see if it is Production.
        return (org.IsSandbox == false);
    }

    /**
    * Author: Brian Armstrong
    * Date: March 8th, 2019
    * Description: This method returns a true value if the organization is a sandbox.
    **/
    public static boolean isSandbox()
    {
        // Query the organization to see if it is a sandbox.
        return (org.IsSandbox == true);
    }

    /**
     * Author: Brian Armstrong
     * Date: March 7th, 2019
     * Description: This method returns a string of the sandbox name if it exists.
     **/
    public static string getSandboxName()
    {
        System.Domain d = System.DomainParser.parse(URL.getOrgDomainUrl());
        string sandboxName = d.getSandboxName();
        
        // If production then sandboxName is null.
        if (null == sandboxName)
            sandboxName = '';   

        //string sandboxName = UserInfo.getUserName().substringAfterLast('.');

        //if (String.isBlank(sandboxName))
        //    sandboxName = 'unknown';

        // if it is com, then it is production.
        //if (sandboxName == 'com')
        //    sandboxName = '';

        return sandboxName;
    }

    /**
     * Author: Brian Armstrong
     * Date: August 22th, 2019
     * Description: This method returns a true value if the id is a contact id.
     **/
    public static boolean isContactId(string id)
    {
        if (null == id || string.isEmpty(id))
            return false;

        return id.startsWith('003');
    }

    /**
     * Author: Brian Armstrong
     * Date: August 22th, 2019
     * Description: This method returns a true value if the id is a contact id.
     **/
    public static boolean isContactId(Id id)
    {
        if (null == id)
            return false;

        return isContactId(String.valueOf(id));
    }

    /**
     * Author: Brian Armstrong
     * Date: August 22th, 2019
     * Description: This method returns a true value if the id is a lead id.
     **/
    public static boolean isLeadId(string id)
    {
        if (null == id || string.isEmpty(id))
            return false;

        return id.startsWith('00Q');
    }

    /**
     * Author: Brian Armstrong
     * Date: August 22th, 2019
     * Description: This method returns a true value if the id is a lead id.
     **/
    public static boolean isLeadId(Id id)
    {
        if (null == id)
            return false;

        return isLeadId(String.valueOf(id));
    }

    /**
    * Author: Brian Armstrong
    * Date: July 14th, 2020
    * Description: This method returns a Salesforce external URL.
    **/
    public static string getSalesforceExternalURL()
    {
        return URL.getSalesforceBaseUrl().toExternalForm() + '/';
    }

    /**
    * Author: Brian Armstrong
    * Date: July 14th, 2020
    * Description: This method returns a Salesforce external URL with the id of the record.
    **/
    public static string getSalesforceExternalURL(Id id)
    {
        if (String.isBlank(id))
            return '';

        return URL.getSalesforceBaseUrl().toExternalForm() + '/' + id;
    }


    /**
    * Author: Brian Armstrong
    * Date: March 5th, 2019
    * Description: This method returns a Limits values in a string format.
    **/
    public static string getLimitsString()
    {
        return getLimitsString(false);
    }

    /**
    * Author: Brian Armstrong
    * Date: March 5th, 2019
    * Description: This method returns a Limits values in a string format.
    **/
    public static string getLimitsString(boolean verbose)
    {
        string s = '';

        if (verbose) {
            s = '1. Total Number of CPU usage time (in ms) allowed in this Apex code context: ' + Limits.getLimitCpuTime() + '\n' +
                    '2. Amount of CPU time (in ms) used so far: ' + Limits.getCpuTime() + '\n' +
                    '3. Number of Queries used in this Apex code so far: ' + Limits.getQueries() + '\n' +
                    '4. Number of rows queried in this Apex code so far: ' + Limits.getDmlRows() + '\n' +
                    '5. Number of DML statements used so far: ' + Limits.getDmlStatements() + '\n';
        } else {
            s = 'CPU usage time allowed: ' + Limits.getLimitCpuTime() + ', ' +
                    'CPU time used: ' + Limits.getCpuTime() + ', ' +
                    'Queries used: ' + Limits.getQueries() + ', ' +
                    'Rows queried: ' + Limits.getDmlRows() + ', ' +
                    'DML statements: ' + Limits.getDmlStatements() + '.';
        }
        return s;
    }

    /**
    * Author: Brian Armstrong
    * Date: Nov 26th, 2019
    * Description: This method returns a Limits values in an HTML string format.
    * @return A formatted string with the limits.
    **/
    public static string getLimitsStringHTML(string heading)
    {
        try {
            string breakTag = '<br />';
            string prefix = ' (';
            string suffix = '), ' + breakTag;
            string lastLineSuffix = ') ' + breakTag;
            string ms = ' ms';
            string bytes = ' bytes';

            return '<p>' + 
                (string.isNotBlank(heading) ? heading + breakTag : '') +  
                'CPU time: ' + Limits.getCpuTime().format() + ms + prefix + Limits.getLimitCpuTime().format() + ms + suffix +
                'Heap size: ' + Limits.getHeapSize().format() + bytes + prefix + Limits.getLimitHeapSize().format() + bytes + suffix +
                //'Database time: ' + Limits.getDatabaseTime() + ms + prefix + Limits.getLimitDatabaseTime() + ms + suffix +
                'Queries used: ' + Limits.getQueries() + prefix + Limits.getLimitQueries() + suffix +
                'Query Locator rows: ' + Limits.getQueryLocatorRows().format() + prefix + Limits.getLimitQueryLocatorRows().format() + suffix +
                'DML rows queried: ' + Limits.getDmlRows().format() + prefix + Limits.getLimitDmlRows().format() + suffix +
                'DML statements: ' + Limits.getDmlStatements() + prefix + Limits.getLimitDmlStatements() + suffix +
                'Publish statements: ' + Limits.getPublishImmediateDML() + prefix + Limits.getLimitPublishImmediateDML() + suffix +
                'Future calls: ' + Limits.getFutureCalls() + prefix + Limits.getLimitFutureCalls() + suffix +
                'Callouts: ' + Limits.getCallOuts() + prefix + Limits.getLimitCallOuts() + suffix +
                'Email Invocations: ' + Limits.getEmailInvocations() + prefix + Limits.getLimitEmailInvocations() + lastLineSuffix +
                '</p>';
        }
        catch (Exception e) {
            return '<p>OrgUtilities.getLimitsStringHTML threw an exception: ' + e.getMessage() + '</p>';
        }
    }

    /**
    * Author: Brian Armstrong
    * Date: Nov 26th, 2019
    * Description: This method returns a Limits values in an HTML string format.
    * @return A formatted string with the limits.
    **/
    public static string getLimitsStringHTML()
    {
        return getLimitsStringHTML('');
    }


    /**
     * Author: Brian Armstrong
     * Date: March 14, 2019.
     * Description: This will get the currentLineNumber in the code.
     * @return an integer with the line number.
     */
    public static Integer getCurrentLineNumber() {
        try {
            //Integer x = 0 / 0;  // Cleanest and smallest exception to throw.
            throw new MathException();
        }
        catch(Exception e) {
            String line2 = e.getStackTraceString().split('\n')[1];
            Pattern patt = Pattern.compile('([a-z0-9_.]+): line (\\d+)');
            Matcher match = patt.matcher(line2);
            match.find();
            return Integer.valueOf(match.group(2));
        }
        //return null;
    }

    /**
     * Author: Brian Armstrong
     * Date: March 14, 2019.
     * Description: This will get the current line of code outside of this method.
     * @return a string with the location of the line of code.
     */
    public static string getCurrentStackLine() {
        try{
            //Integer x = 0 / 0; // Cleanest and smallest exception to throw.
            throw new MathException();
        }
        catch(Exception e) {
            String line2 = e.getStackTraceString().split('\n')[1];
            return line2;
        }
        //return null;
    }


    /**
    * Author: Brian Armstrong
    * Date: March 5th, 2019
    * Description: This method returns a string in HTML format.
    **/
    public static string getExceptionStringHTML(Exception e)
    {
        //return '<p>Exception type: ' + e.getTypeName() + '</p>' +
        //       '<p>Message: ' + e.getMessage() + '</p>' +
        //       (null != e.getCause() ? '<p>Cause: ' + e.getCause() + '</p>' : '') + // returns null
        //       '<p>Line number: ' + e.getLineNumber() + '<br />' +
        //       'Stack trace: ' + e.getStackTraceString() + '</p>';

        String stackTrace = e.getStackTraceString().replace('\n', '<br/>');  // change new line to html break.
        return '<p>Exception type: ' + e.getTypeName() + '</p>' +
                (null != e.getCause() ? '<p>Cause: ' + e.getCause() + '</p>' : '') + // returns null
                //'<p>Line number: ' + e.getLineNumber() + '<br />' +
                '<p>Message: ' + e.getMessage() + '</p>' +
                '<p>Stack trace: ' + stackTrace + '</p>';
    }


    /**
    * Author: Brian Armstrong
    * Date: Nov 25th, 2019
    * Description: This method returns a string in HTML format of the User Info.
    **/
    public static string getUserInfoString()
    {
        final String formatDTLocal = 'yyyy-MM-dd HH:mm:ss z';
        final String formatDTGMT = formatDTLocal;
        DateTime dt = Datetime.now();

        return 'Org id: ' + UserInfo.getOrganizationId() +
                (isSandbox() ? ', Sandbox name: ' + getSandboxName() + '' : ', ' + PRODUCTION_ORGANIZATION) +
                ', Time: ' + dt.formatGmt(formatDTGMT) + ', Local: ' + dt.format(formatDTLocal, UserInfo.getTimeZone().toString()) +
                '\n' +
                'User id: ' + UserInfo.getUserId() +
                ', User name: ' + UserInfo.getUserName() +
                ', Time zone: ' + UserInfo.getTimeZone().getDisplayName() +
                ', Profile id: ' + UserInfo.getProfileId() +
                '\n';
    }

    /**
    * Author: Brian Armstrong
    * Date: Nov 25th, 2019
    * Description: This method returns a string in HTML format of the User Info.
    **/
    public static string getUserInfoStringHTML()
    {
        final String formatDTGMT = 'yyyy-MM-dd HH:mm:ss.SSS z';
        final String formatDTLocal = 'yyyy-MM-dd HH:mm:ss.SSS z (\'GMT\'Z zzzzz)';

        try {
            DateTime dt = Datetime.now();
            TimeZone userTZ = UserInfo.getTimeZone();
            string s;

            /* Version 1 and 2
            s = '<p>Org id: ' + UserInfo.getOrganizationId() +
            //(!String.IsBlank(getSandboxName()) ? ', Sandbox name: ' + getSandboxName() + '' : ', Production') +
            (isSandbox() ? ', Sandbox name: ' + getSandboxName() + '' : ', Production') +
            ', Time: ' + dt.formatGmt(formatDTGMT) + ', Local: ' + dt.format(formatDTLocal, UserInfo.getTimeZone().toString()) +
            '<br />' +
            'User id: ' + UserInfo.getUserId() +
            ', User name: ' + UserInfo.getUserName() +
            ', Time zone: ' + UserInfo.getTimeZone().getDisplayName() +
            ', Profile id: ' + UserInfo.getProfileId() +
            '</p>';
            */

            // Version 3
            s = '<p>' + (isSandbox() ? 'Sandbox: ' + getSandboxName() : PRODUCTION_ORGANIZATION) +
                ', Org Id: ' + Id.valueOf(org.Id).to15() + ' (' + org.InstanceName + ')' +
                //', Locale: ' + org.DefaultLocaleSidKey +
                //', Time: ' + dt.formatGmt(formatDTGMT) + ', Local: ' + dt.format(formatDTLocal, userTZ.toString()) +
                ', Time: ' + dt.formatGmt(formatDTGMT) + ' (Org: ' + dt.format(formatDTLocal, org.TimeZoneSidKey) + ', User: ' + dt.format(formatDTLocal, userTZ.toString()) +')'+
                '<br />' +
                'Username: ' + UserInfo.getUserName() +
                ', Email: ' + UserInfo.getUserEmail() +
                ', Id: ' + Id.valueOf(UserInfo.getUserId()).to15() +
                ', Profile Id: ' + Id.valueOf(UserInfo.getProfileId()).to15() +
                ', Role Id: ' + (null == UserInfo.getUserRoleId() ? 'null' : Id.valueOf(UserInfo.getUserRoleId()).to15()) +
                ', Name: ' + UserInfo.getName() +
                //', Session Id: ' + UserInfo.getSessionId()  +
                ', Timezone: ' + userTZ.getDisplayName() + ' (' + userTZ.getID() + ')' +
                '</p>';

                
            return s;
        }
        catch (Exception e) {
            return '<p>OrgUtilities.getUserInfoStringHTML threw an exception: ' + e.getMessage() + ',<br/>Stack Trace: ' + e.getStackTraceString() + '</p>';
        }
    }

    /**
    * Author: Brian Armstrong
    * Date: Oct 07th, 2020.
    * Description: This method emails the status message to the status email addresses.
    **/
    public static void sendStatusByEmail(String className, String methodName, String subject, String message) {
        List <String> emailsAddresses = STATUS_EMAIL_ADDRESSES;
        String htmlBody = getUserInfoStringHTML() +
                '<p>Class name: ' + className + '<br />' +
                'Method name: ' + methodName + '</p>' +
                '<p>Message: ' + message + '</p>'+
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(emailsAddresses, htmlBody, subject);
    }

    /**
    * Author: Brian Armstrong
    * Date: Oct 07th, 2020.
    * Description: This method emails the status message to the status email addresses.
    **/
    public static void sendStatusByEmail(String className, String methodName, String subject, String message, List <String> toAddresses)  {
        String htmlBody = getUserInfoStringHTML() +
                '<p>Class name: ' + className + '<br />' +
                'Method name: ' + methodName + '</p>' +
                '<p>Message: ' + message + '</p>'+
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(toAddresses, htmlBody, subject);
    }

    /**
    * Author: Brian Armstrong
    * Date: March 11th, 2019.
    * Description: This method emails the error message to the error email addresses.
    **/
    public static void sendErrorByEmail(String className, String methodName, String message) {
        List <String> emailsAddresses = ERROR_EMAIL_ADDRESSES;
        String subject = ERROR_SUBJECT;
        String htmlBody = getUserInfoStringHTML() +
                '<p>Class name: ' + className + '<br />' +
                'Method name: ' + methodName + '</p>' +
                '<p>Message: ' + message + '</p>'+
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(emailsAddresses, htmlBody, subject);
    }


    /**
    * Author: n/a
    * Date: n/a
    * Description: This method emails an exception.
    **/
    public static void sendExceptionByEmail(Exception e, String className, String methodName, String message) {
        List <String> emailsAddresses = EXCEPTION_EMAIL_ADDRESSES;
        String subject = EXCEPTION_SUBJECT;
        String htmlBody = getUserInfoStringHTML() +
                '<p>Class name: ' + className + '<br />' +
                'Method name: ' + methodName + '<br />' +
                'Line number: ' + e.getLineNumber() + '</p>' +
                '<p>Message: ' + message + '</p>' +
                '<p><b>Exception:</b></p>' + getExceptionStringHTML(e) +
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(emailsAddresses, htmlBody, subject);
    }

    /**
    * Author: Brian Armstrong
    * Date: March 15, 2019
    * Description: This method emails an exception.
    **/
    public static void sendExceptionByEmail(Exception e, String triggerName, String message) {
        List <String> emailsAddresses = EXCEPTION_EMAIL_ADDRESSES;
        String subject = EXCEPTION_SUBJECT;
        String htmlBody = getUserInfoStringHTML() +
                '<p>Trigger name: ' + triggerName + '</p>' +
                '<p>Message: ' + message + '</p>' +
                '<p><b>Exception:</b></p>' + getExceptionStringHTML(e) +
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(emailsAddresses, htmlBody, subject);
    }

    /**
    * Author: Brian Armstrong
    * Date: March 15, 2019
    * Description: This method emails an exception.
    **/
    public static void sendExceptionByEmail(Exception e, ApexPages.StandardController stdController, String controllerName, String methodName, String message) {
        List <String> emailsAddresses = EXCEPTION_EMAIL_ADDRESSES;
        String subject = EXCEPTION_SUBJECT;
        String htmlBody = getUserInfoStringHTML() +
                '<p>Controller name: ' + controllerName + '<br />' +
                'Method name: ' + methodName + '<br />' +
                'Controller Id: ' + stdController.getId() + '</p>' +
                '<p>Message: ' + message + '</p>' +
                '<p><b>Exception:</b></p>' + getExceptionStringHTML(e) +
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(emailsAddresses, htmlBody, subject);
    }

    /**
    * Author: n/a
    * Date: n/a
    * Description: This method emails the exception information.
    **/
    public static void sendExceptionByEmail(String objectName, String className, String methodName, String message)
    {
        List <String> emailAddresses = EXCEPTION_EMAIL_ADDRESSES;
        String subject = EXCEPTION_SUBJECT;
        String htmlBody = getUserInfoStringHTML() +
                '<p>Object "' + objectName + '", threw an exception in the ' + methodName + ' method in the ' + className + ' class.</p>' +
                '<p>Message: ' + message + '</p>' +
                'Thanks,<br />Corporate Systems Team' +
                '<p><b>Limits:</b></p>' + getLimitsStringHTML();

        sendEmail(emailAddresses, htmlBody, subject);
    }

    /**
    * Author: EL and Brian Armstrong
    * Date: June 8, 2015
    * Description: This method sends an email.
    **/
    public static void sendEmail(List <String> toAddresses, String htmlBody, String subject)
    {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setHtmlBody(htmlBody);
        mail.saveAsActivity = false;
        mail.useSignature = false;

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.Email>{mail});
        if (!results.get(0).isSuccess()) {
            System.StatusCode statusCode = results.get(0).getErrors()[0].getStatusCode();
            String errorMessage = results.get(0).getErrors()[0].getMessage();
            System.debug('OrgUtilities.sendEmail failed on Messaging.sendEmail: ' + errorMessage);
            System.debug('htmlBody:0:'+ htmlBody);
        }
    }

    public class SalesforceAPIVersionResponse
    {
        public String label;
        public String url;
        public String version;
    }

    // Currently this code can not be called from a scheduled class.  It needs to have some work.
    // An error will occur: Callout from scheduled Apex not supported.
    public static String getLatestAPIVersionString()
    {
        String url = URL.getSalesforceBaseUrl().toExternalForm() + '/services/data';
        //system.debug('Url: ' + url);

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setHeader('Content-Type', 'application/json');

        String json = '<error>';
        if (test.isRunningTest()) {
            json = '[{"label":"Spring \'11","url":"/services/data/v21.0","version":"21.0"},{"label":"Summer \'11","url":"/services/data/v22.0","version":"22.0"}]';
        } else {
            Http http = new Http();
            HTTPResponse resp = http.send(req);

            json = resp.getBody();
            //system.debug('Body: ' + json);
        }

        List<SalesforceAPIVersionResponse> parsedList = (List<SalesforceAPIVersionResponse>)System.JSON.deserialize(json, List<SalesforceAPIVersionResponse>.class);
        //system.debug('Parsed Body: ' + parsedList);

        String latestVersion = '0';
        String latestVersionString = json;
        for (SalesforceAPIVersionResponse item : parsedList)
        {
            if (latestVersion.compareTo(item.version) < 0)
            {
                latestVersion = item.version;
                latestVersionString = item.label + ' v' + item.version;
            }
        }
        //system.debug('Latest Version: ' + latestVersion);
        //system.debug('Latest Version String: ' + latestVersionString);

        return latestVersionString;
    }


    /**
    * Author: Brian Armstrong
    * Date: October 7th, 2019
    * Description: Return a string that is used in system.debug calls to make it easier to find in debug logs.
    **/
    public enum AsciiArtEnum {MARKER, CAT, FISH_LEFT, FISH_RIGHT, SCORPION, SCORPION_UNICODE, ELF, ROBOT, PERSON}
    public static string AsciiArtString(AsciiArtEnum key){
        Map<AsciiArtEnum, string> asciiArtStrings = new Map<AsciiArtEnum, String>{
                AsciiArtEnum.MARKER => '*-*',
                AsciiArtEnum.CAT => '(=°•°=)',
                AsciiArtEnum.FISH_LEFT => '<°))))><',
                AsciiArtEnum.FISH_RIGHT => '><((((°>',
                AsciiArtEnum.SCORPION => 'c---|-|-|-|{',
                AsciiArtEnum.SCORPION_UNICODE => '\uD83E\uDD82',
                AsciiArtEnum.ELF => '*<|:-)',
                AsciiArtEnum.ROBOT => 'd[o_O]b',
                AsciiArtEnum.PERSON => '\\__(.^.)__/'};

        return asciiArtStrings.get(key);
    }

}