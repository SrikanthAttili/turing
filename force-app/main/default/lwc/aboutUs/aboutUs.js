import { LightningElement, wire } from "lwc"; // Import necessary modules from LWC
import getCustomLabels from "@salesforce/apex/CustomLabelsUtility.getCustomLabels";
import LANG from "@salesforce/i18n/lang"; // Import language setting

export default class AboutUs extends LightningElement {
  language = LANG; // Store the current language setting in 'language' property
  error; // Property to store any error encountered during fetching
  aboutUsLabel;
  aboutus;
  @wire(getCustomLabels) // Wire the Apex method to fetch custom labels
  getLabels({ error, data }) {
    if (data) {
      this.aboutUslabel = data.Aboutus_Label;
      this.aboutus = data.Aboutus;
      this.error = undefined; // Clear any previous error
    } else if (error) {
      this.error = error?.body?.message; // Assign error message to 'error' property
    }
  }
}
