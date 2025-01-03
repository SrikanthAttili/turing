public with sharing class CustomLabelsUtility {
  // Method exposed to Aura components to fetch custom labels, cacheable for improved performance
  @AuraEnabled(cacheable=true)
  public static Map<String, String> getCustomLabels() {
    // Initialize a list to store custom label values
    Map<String, String> customLabelToTranslatedValue = new Map<String, String>();

    try {
      // Query metadata to retrieve custom label details with security enforced
      List<FilteredCustomLabels__mdt> filteredCustomLabels = [
        SELECT MasterLabel, QualifiedApiName
        FROM FilteredCustomLabels__mdt
        WITH SECURITY_ENFORCED
      ];

      // Fetch the language preference of the current user
      String userLanguage = UserInfo.getLanguage();

      // Iterate through the retrieved custom labels
      for (
        FilteredCustomLabels__mdt filteredCustomLabel : filteredCustomLabels
      ) {
        // Check if a translation exists for the user's language
        if (
          Label.translationExists(
            '',
            filteredCustomLabel.QualifiedApiName,
            userLanguage
          )
        ) {
          // Add the translated label to the list
          customLabelToTranslatedValue.put(
            filteredCustomLabel.QualifiedApiName,
            Label.get('', filteredCustomLabel.QualifiedApiName, userLanguage)
          );
        } else {
          // Add the default label if no translation exists
          customLabelToTranslatedValue.put(
            filteredCustomLabel.QualifiedApiName,
            Label.get('', filteredCustomLabel.QualifiedApiName)
          );
        }
      }
      // Integer i = 10 / 0; un comment it, when u want to test the error handling
    } catch (Exception e) {
      // Log the error for debugging purposes
      System.debug('Error retrieving custom labels: ' + e.getMessage());

      // Throw a user-friendly error message for the front-end
      throw new AuraHandledException(
        'Unable to fetch custom labels. Please try again later.'
      );
    }

    // Return the list of custom labels
    return customLabelToTranslatedValue;
  }
}
