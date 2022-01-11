<h1 align="center">Progress Trail</h1>

<p align="center">This package includes an Aura component that displays a modified Path component on a record page.</p>

<!-- Sections below are Optional -->

---

## Description

Progress Trail provides better status-based guidance and actions for end users on any record.

The best way to describe it is to show how it compares to the standard Path component:

| Feature | PATH | PROGRESS TRAIL |
| :--- | :---: | :---: | 
| Display a path/progress indicator | ✅ | ✅ |
| Expand/collapse Guidance for Success | ✅ | ✅ |
| Display rich text guidance (specific to the current value in the path) | ✅ | ✅ |
| Display record fields to complete (specific to the current value in the path) | ✅ | ✅ |
| Display an embedded flow (specific to the current value in the path) | ❌ | ✅ |
| Display different guidance to different audiences (internal vs external user guidance) | ❌ | ✅ |
| Available to use on all standard and custom objects (including Case) | ❌ | ✅ |
| Mix and match the type of guidance provided to end users from step-to-step in the path | ❌ | ✅ |
| Display different versions of a path/guidance based on something other than record type (e.g. Profile, Role, If Record Owner, field value...) | ❌ | ✅ |
| Allow guidance to be displayed in expanded view by default everytime the record is loaded | ❌ | ✅ |
| Hide Mark as Complete button in Experience Cloud sites | ❌ | ✅ |
| Hide extraneous labels (current status and "Guidance for Success") that take up space | ❌ | ✅ |
| Editable/configurable by non-system administrator (e.g. a business process owner / super user) | ❌ | ✅ |

Progress Trail comes with a few features to make it easy to get started:
- A setup app, called "Progress Trail Setup".
- A flow for quickly creating a Progress Trail for any object and picklist field; it auto-creates child segment records based on the active values in your designated picklist.
- An even simpler flow for quickly creating a trail for the Case object based on the Status field.
- A user permission set, called "Progress Trail Component Access".

## Install & Setup Instructions

**Please see the [Disclaimer](https://github.com/SFDC-Assets/ProgressTrail#disclaimer)** (below)

1. **Install for all users from the AppExchange: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t6g000007zKTC**
  
2. **Create a new Progress Trail:**
        <ol>
          <li>From the App Launcher, select the Progress Trail Setup app.</li>
          <li>On the Progress Trail Setup tab, use the embedded flow to create your Progress Trail.  This requires you to provide a unique name, the API names of the object and picklist field you wish to use.  The flow auto-creates a Trail Progress Segment record for every active picklist value.  Don’t worry - the only values that will display in the component are the ones used by the record’s record type.</li>
          <li>Edit the fields for each Progress Trail Segment record to configure the guidance your users will see.</li>
        </ol>
  
3. **Add the Progress Trail component to your record page**.  Ensure that you refer to the name of the Progress Trail you wish to use before you save.

4. **Give Your Users Permissions**. If your users can't see the component or the objects, you are thwarted. Assign them the "Progress Trail Component Access" permission set.

### Component Properties

When you add this component to a Flow screen, there are a few properties to configure:

| Attribute     							| Description	|
| :----------------------------------------- | :------------- |
| **Trail Name** | Name of the Progress Trail you want to use for this record page. |
| **Trail Audience** | Is this component being displayed to internal or external users? |
| **Show Path** | Display the progress path? |
| **Trail Expanded by Default** | Is the trail guidance displayed as expanded by default when the page loads? This setting doesn't matter if you don't show the path. |

## Additional Documentation

### Objects

The component uses two objects to store information about the Progress Trail you want to display on a record page.

#### Progress_Trail__c
This object stores info about the trail you want to use for a specific object and field:

| Field Name                        | Description     |
| :-------------------------------- | :-------------- |
| **Name**                          | Name of the trail. Must be unique so that it will be used whenever you reference it in the component properties. |
| **Related_Object_API_Name__c**    | Name of the object the trail is for (e.g. Case or My_Custom_Object__c). |
| **Field_API_Name__c**             | Name of the picklist field you want to use to show all the values in the progress path (e.g. Status or My_Custom_Picklist__c). |


#### Progress_Trail_Segment__c
This object is a child to Progress_Trail__c and stores your configuration for each picklist field value used by a trail.  For settings that are audience-specific, there are separate fields that will be used for internal and external users:

| Field Name                                          | Description     |
| :-------------------------------------------------- | :-------------- |
| **External_Guidance_Active_Type__c**                | Do you wish for external users to see rich text guidance or a flow for this segment? Only the selected option will be displayed. |
| **External_Guidance_Text__c**                       | Rich text that will be shown to external users (if selected as the active type). |
| **External_Guidance_Flow_API_Name__c**              | API name of the Flow that will be shown to external users (if selected as the active type). |
| **Internal_Guidance_Active_Type__c**                | Do you wish for internal users to see rich text guidance or a flow for this segment? Only the selected option will be displayed. |
| **Internal_Guidance_Text__c**                       | Rich text that will be shown to internal users (if selected as the active type). |
| **Internal_Guidance_Flow_API_Name__c**              | API name of the Flow that will be shown to internal users (if selected as the active type). |
| **Name**                                            | Name of your segment has to exactly match the picklist value, so I wouldn't edit these. |
| **Pass_RecordId_to_External_Flow_if_Active__c**     | If "Display Flow" is the active choice for external users, do you wish to pass the current record's Id to Flow as a flow input variable called 'recordId'? If this is checked but you don't have an input variable called recordId, the user will get a fow error message. |
| **Pass_RecordId_to_Internal_Flow_if_Active__c**     | If "Display Flow" is the active choice for internal users, do you wish to pass the current record's Id to Flow as a flow input variable called 'recordId'? If this is checked but you don't have an input variable called recordId, the user will get a fow error message. |
| **Progress_Trail__c**                               | Parent Progress Trail this segment is related to. |

## FAQ

*None at present*

## Release History

1.4 Beta release (11 Jan 2022)

## Maintainers

[Mitch Lynch / egyptguy](https://github.com/egyptguy)

## Disclaimer

THIS APPLICATION IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, CONSEQUENTIAL OR SIMILAR DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS APPLICATION, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SUBJECT TO THE FOREGOING, THIS APPLICATION MAY BE FREELY REPRODUCED, DISTRIBUTED, TRANSMITTED, USED, MODIFIED, BUILT UPON, OR OTHERWISE EXPLOITED BY OR ON BEHALF OF SALESFORCE.COM OR ITS AFFILIATES, ANY CUSTOMER OR PARTNER OF SALESFORCE.COM OR ITS AFFILIATES, OR ANY DEVELOPER OF APPLICATIONS THAT INTERFACE WITH THE SALESFORCE.COM APPLICATION, FOR ANY PURPOSE, COMMERCIAL OR NON-COMMERCIAL, RELATED TO USE OF THE SALESFORCE.COM APPLICATION, AND IN ANY WAY, INCLUDING BY METHODS THAT HAVE NOT YET BEEN INVENTED OR CONCEIVED.
