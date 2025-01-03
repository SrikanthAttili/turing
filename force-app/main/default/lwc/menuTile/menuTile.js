import { LightningElement, api, wire } from "lwc";
import getCustomLabels from "@salesforce/apex/CustomLabelsUtility.getCustomLabels";
/**
 * A presentation component to display a Menu__c sObject. The provided
 * Menu__c data must contain all fields used by this component.
 */
export default class MenuTile extends LightningElement {
  _menu;
  /** Menu__c field values to display. */
  imageUrl;
  name;
  price;
  description;
  type;
  customLabels;
  /** Menu__c to display. */
  @api
  get menu() {
    return this._menu;
  }
  set menu(value) {
    this._menu = value;
    this.imageUrl = value.Image__c;
    this.name = value.Name;
    this.price = value.Price__c;
    this.description = value.Short_Description__c;
  }

  @wire(getCustomLabels) // Wire the Apex method to fetch custom labels
  getLabels({ error, data }) {
    if (data) {
      this.customLabels = data; // Assign fetched data to 'labels' property
      // console.log("Custom Labels: ", JSON.stringify(this.customLabels.Price));
      this.error = undefined; // Clear any previous error
    } else if (error) {
      this.error = error?.body?.message; // Assign error message to 'error' property
      this.labels = undefined; // Clear any previous labels
    }
  }
}
