<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_when_Big_Deal_Created</fullName>
        <description>Email Notification when Big Deal Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>bogdan.manager@pavlyk.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bogdan@pavlyk.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SalesNewCustomerEmail</template>
    </alerts>
    <rules>
        <fullName>Big Deal Notification</fullName>
        <actions>
            <name>Email_Notification_when_Big_Deal_Created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>equals</operation>
            <value>2/11/2016</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>1000000</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
