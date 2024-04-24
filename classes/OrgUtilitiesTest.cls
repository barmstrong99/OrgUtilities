@isTest
/*
 * Description: Test the methods in the OrgUtilities class.
*/
public class OrgUtilitiesTest
{

    public static final List <String> STATUS_EMAIL_ADDRESSES = new List<String>{'some.user@company.com'};  // Used for sending status update emails.

    /*
     Author: Brian Armstrong
     Date: August 20th, 2021
     Description: Test the isProduction method.
     */
    static testMethod void TestIsProduction()
    {
        boolean isProd = null;
        Integer numQueries = Limits.getQueries();
        System.debug('NumQueries: ' + numQueries);
        isProd = OrgUtilities.isProduction();
        numQueries = Limits.getQueries();
        System.debug('isProduction: ' + isProd + ' NumQueries: ' + numQueries);
        isProd = OrgUtilities.isProduction();
        numQueries = Limits.getQueries();
        System.debug('isProduction: ' + isProd + ' NumQueries: ' + numQueries);
        isProd = OrgUtilities.isProduction();
        numQueries = Limits.getQueries();
        System.debug('isProduction: ' + isProd + ' NumQueries: ' + numQueries);
        System.assertEquals(true, true, 'isProduction');
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the isSandbox method.
    */
    static testMethod void TestIsSandbox()
    {
        boolean isSB = null;
        Integer numQueries = Limits.getQueries();
        System.debug('NumQueries: ' + numQueries);
        isSB = OrgUtilities.isSandbox();
        numQueries = Limits.getQueries();
        System.debug('isSandbox: ' + isSB + ' NumQueries: ' + numQueries);
        isSB = OrgUtilities.isSandbox();
        numQueries = Limits.getQueries();
        System.debug('isSandbox: ' + isSB + ' NumQueries: ' + numQueries);
        isSB = OrgUtilities.isSandbox();
        numQueries = Limits.getQueries();
        System.debug('isSandbox: ' + isSB + ' NumQueries: ' + numQueries);
        System.assertEquals(true, true, 'isSandbox');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019
    Description: Test the getSandboxName method.
    */
    static testMethod void TestGetSandboxName()
    {
        string sandboxName = OrgUtilities.getSandboxName();
        System.debug('getSandboxName: ' + sandboxName);
        if (OrgUtilities.isSandbox()) {
            System.assertEquals(true, string.isNotEmpty(sandboxName), 'getSandboxName');
        }
    }

    /*
    Author: Brian Armstrong
    Date: August 22nd, 2019
    Description: Test the isContactId method.
    */
    static testMethod void TestIsContactId()
    {
        System.assertEquals(false, OrgUtilities.isContactId(''), 'isContactId');
        System.assertEquals(true, OrgUtilities.isContactId('0030m0000000000'), 'isContactId');
        System.assertEquals(false, OrgUtilities.isContactId('001330000000000'), 'isContactId');

        Id id = null;
        System.assertEquals(false, OrgUtilities.isContactId(id), 'isContactId');
        id = '0030m0000000000';
        System.assertEquals(true, OrgUtilities.isContactId(id), 'isContactId');
        id = '001330000000000';
        System.assertEquals(false, OrgUtilities.isContactId(id), 'isContactId');
    }

    /*
    Author: Brian Armstrong
    Date: August 22nd, 2019
    Description: Test the isLeadId method.
    */
    static testMethod void TestIsLeadId()
    {
        System.assertEquals(false, OrgUtilities.isLeadId(''), 'isLeadId');
        System.assertEquals(true, OrgUtilities.isLeadId('00Q330000000000'), 'isLeadId');
        System.assertEquals(false, OrgUtilities.isLeadId('001330000000000'), 'isLeadId');

        Id id = null;
        System.assertEquals(false, OrgUtilities.isLeadId(id), 'isLeadId');
        id = '00Q330000000000';
        System.assertEquals(true, OrgUtilities.isLeadId(id), 'isLeadId');
        id = '001330000000000';
        System.assertEquals(false, OrgUtilities.isLeadId(id), 'isLeadId');
    }

    /*
     Author: Brian Armstrong
     Date: July 14th, 2020
     Description: Test the getSalesforceExternalURL method.
    */
    static testMethod void TestGetSalesforceExternalURL()
    {
        string externalURL = OrgUtilities.getSalesforceExternalURL('500f30000000000000');
        System.debug('externalURL: ' + externalURL);
        System.assertEquals(true, string.isNotEmpty(externalURL), 'externalURL');

        externalURL = OrgUtilities.getSalesforceExternalURL(null);
        System.debug('externalURL: ' + externalURL);
        System.assertEquals(false, string.isNotEmpty(externalURL), 'externalURL');

        externalURL = OrgUtilities.getSalesforceExternalURL();
        System.debug('externalURL: ' + externalURL);
        System.assertEquals(true, string.isNotEmpty(externalURL), 'externalURL');
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getLimitsString method.
    */
    static testMethod void TestGetLimitsString()
    {
        string limitsString = OrgUtilities.getLimitsString(true);
        System.debug('getLimitsString: ' + limitsString);
        System.assertEquals(true, string.isNotEmpty(limitsString), 'getLimitsString');

        limitsString = OrgUtilities.getLimitsString(false);
        System.debug('getLimitsString: ' + limitsString);
        System.assertEquals(true, string.isNotEmpty(limitsString), 'getLimitsString');

        limitsString = OrgUtilities.getLimitsString();
        System.debug('getLimitsString: ' + limitsString);
        System.assertEquals(true, string.isNotEmpty(limitsString), 'getLimitsString');
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getLimitsStringHTML method.
    */
    static testMethod void TestGetLimitsStringHTML()
    {
        string limitsString = OrgUtilities.getLimitsStringHTML();
        System.debug('getLimitsStringHTML: ' + limitsString);
        System.assertEquals(true, string.isNotEmpty(limitsString), 'getLimitsStringHTML');
        
        limitsString = OrgUtilities.getLimitsStringHTML('<b>Limits:</b>');
        System.debug('getLimitsStringHTML: ' + limitsString);
        System.assertEquals(true, string.isNotEmpty(limitsString), 'getLimitsStringHTML');
    }

    /*
     Author: Brian Armstrong
     Date: March 8th, 2019
     Description: Test the getExceptionStringHTML method.
     */
    static void TestGetExceptionStringA()
    {
        Exception e = new MathException('Test that throws math exception.');
        e.initCause(new StringException('Test string exception for a cause.'));
        throw e;
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getExceptionStringHTML method.
    */
    static void TestGetExceptionStringB()
    {
        TestGetExceptionStringA();
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getExceptionStringHTML method.
    */
    static void TestGetExceptionStringC()
    {
        TestGetExceptionStringB();
    }
	
    /* Brian Armstrong
    Author:
    Date: March 8th, 2019
    Description: Test the getExceptionStringHTML method.
    */
    static void TestGetExceptionStringD()
    {
        TestGetExceptionStringC();
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getExceptionStringHTML method.
    */
    static testMethod void TestGetExceptionStringHTML()
    {
        try{
            //Integer x = 0 / 0; // Cleanest and smallest exception to throw.
            //throw new MathException();
            TestGetExceptionStringD();
        }
        catch(Exception e) {
            string s = OrgUtilities.getExceptionStringHTML(e);
            System.debug('getExceptionStringHTML: ' + s);
            System.assertEquals(true, string.isNotEmpty(s), 'getExceptionStringHTML');
        }
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getUserInfoString and getUserInfoStringHTML method.
    */
    static testMethod void TestGetUserInfoString()
    {
        System.debug('UserInfo.getTimeZone().toString(): ' + UserInfo.getTimeZone().toString());

        string s = OrgUtilities.getUserInfoString();
        System.debug('getUserInfoString: ' + s);
        System.assertEquals(true, string.isNotEmpty(s), 'getUserInfoString');
    }

    /*
    Author: Brian Armstrong
    Date: March 8th, 2019
    Description: Test the getUserInfoString and getUserInfoStringHTML method.
    */
    static testMethod void TestGetUserInfoStringHTML()
    {
        System.debug('UserInfo.getTimeZone().toString(): ' + UserInfo.getTimeZone().toString());
        System.debug('UserInfo.getTimeZone().getDisplayName(): ' + UserInfo.getTimeZone().getDisplayName());
        System.debug('UserInfo.getTimeZone().getID(): ' + UserInfo.getTimeZone().getID());

        String s = OrgUtilities.getUserInfoStringHTML();
        System.debug('getUserInfoStringHTML: ' + s);
        System.assertEquals(true, string.isNotEmpty(s), 'getUserInfoStringHTML');
    }

    /**
     * Author: Brian Armstrong
     * Date: March 14, 2019
     * Description: Test the getCurrentLineNumber method.
     */
    static testMethod void TestGetCurrentLineNumber()
    {
        Integer lineNumber = OrgUtilities.getCurrentLineNumber();
        System.debug('getCurrentLineNumber: ' + lineNumber);
        System.assertEquals(true, (lineNumber > 0), 'getCurrentLineNumber');
    }

    /**
     * Author: Brian Armstrong
     * Date: March 14, 2019
     * Description: Test the getCurrentStackLine method.
     */
    static testMethod void TestGetCurrentStackLine()
    {
        string stackLine = OrgUtilities.getCurrentStackLine();
        System.debug('getCurrentStackLine: ' + stackLine);
        System.assertEquals(true, (stackLine.length() > 0), 'getCurrentStackLine');
    }


    /*
    Author: Brian Armstrong
    Date: March 11th, 2019
    Description: Test the sendErrorByEmail method.
    */
    static testMethod void TestSendStatusByEmail1()
    {
        OrgUtilities.sendStatusByEmail('className', 'methodName', 'statusSubject', 'statusMessage');
        System.assertEquals(true, true, 'sendStatusByEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 11th, 2019
    Description: Test the sendErrorByEmail method.
    */
    static testMethod void TestSendStatusByEmail2()
    {
        OrgUtilities.sendStatusByEmail('className', 'methodName', 'statusSubject', 'statusMessage', STATUS_EMAIL_ADDRESSES);
        System.assertEquals(true, true, 'sendStatusByEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 11th, 2019
    Description: Test the sendErrorByEmail method.
    */
    static testMethod void TestSendErrorByEmail1()
    {
        OrgUtilities.sendErrorByEmail('className', 'methodName', 'errorMessage');
        System.assertEquals(true, true, 'sendErrorByEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019
    Description: Test the sendExceptionByEmail method.
    */
    static testMethod void TestSendExceptionByEmail1()
    {
        try {
            throw new OrgException('Exception Test');
        }
        catch(Exception e) {
            OrgUtilities.sendExceptionByEmail(e, 'className', 'methodName', 'message');
        }
        System.assertEquals(true, true, 'sendExceptionByEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019
    Description: Test the sendExceptionByEmail method.
    */
    static testMethod void TestSendExceptionByEmail2()
    {
        try {
            throw new OrgException('Exception Test');
        }
        catch(Exception e) {
            OrgUtilities.sendExceptionByEmail(e, 'triggerName', 'message');
        }
        System.assertEquals(true, true, 'sendExceptionByEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019
    Description: Test the sendExceptionByEmail method.
    */
    static testMethod void TestSendExceptionByEmail4()
    {
        Account a = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(a);

        try {
            throw new OrgException('Exception Test');
        }
        catch(Exception e) {
            OrgUtilities.sendExceptionByEmail(e, sc, 'controllerName', 'methodName', 'message');
        }
        System.assertEquals(true, true, 'sendExceptionByEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019.
    Description: Test the sendEmail method in the OrgUtilities.
    */
    static testMethod void TestSendEmail1()
    {
        OrgUtilities.sendEmail(new List <String>{'test@company.com.test'}, 'htmlBody', 'subject');
        System.assertEquals(true, true, 'sendEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019.
    Description: Test the sendEmail method in the OrgUtilities.
    */
    static testMethod void TestSendEmail2()
    {
        OrgUtilities.sendEmail(new List <String>{'test@company.com.test'}, 'htmlBody', 'subject', new List <String>{'test@company.com.test'});
        System.assertEquals(true, true, 'sendEmail');
    }

    /*
    Author: Brian Armstrong
    Date: March 5th, 2019.
    Description: Test the sendExceptionByEmail in the OrgUtilities.
    */
    static testMethod void TestSendExceptionByEmail3()
    {
        OrgUtilities.sendExceptionByEmail('objectName', 'className', 'fileName', 'message');
        System.assertEquals(true, true, 'sendExceptionByEmail');
    }


    /*
    Author: Brian Armstrong
    Date: August 12th, 2021
    Description: Test the AsciiArtString method.
    */
    static testMethod void TestgetLatestAPIVersionString()
    {
        string s = OrgUtilities.getLatestAPIVersionString();
        system.debug('getLatestAPIVersionString: ' + s);
        System.assertEquals(String.IsBlank(s), false, 'getLatestAPIVersionString: ' + s);
    }


    /*
    Author: Brian Armstrong
    Date: October 7th, 2019
    Description: Test the AsciiArtString method.
    */
    static testMethod void TestAsciiArtString()
    {
        for (OrgUtilities.AsciiArtEnum asciiArt : OrgUtilities.AsciiArtEnum.values()) {
            string s = OrgUtilities.AsciiArtString(asciiArt);
            System.assertEquals(String.IsBlank(s), false, 'AsciiArtString. Enum: ' + asciiArt);
        }
    }

    /**
     * Setup any test data needed by the test class.
     */
    @testSetup static void setup()
    {
        // Create test data below.
    }

}