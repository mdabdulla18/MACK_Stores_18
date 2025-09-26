import { LightningElement, track } from 'lwc';
import createReliefCase from '@salesforce/apex/ReliefCaseController.createReliefCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ReliefCaseIntakeForm extends LightningElement {
    @track name = '';
    @track description = '';
    @track email = '';

    handleNameChange(event) {
        this.name = event.target.value;
    }
    handleDescriptionChange(event) {
        this.description = event.target.value;
    }
    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleSubmit() {
        createReliefCase({ name: this.name, description: this.description, contactEmail: this.email })
            .then(result => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Relief Case created successfully!',
                    variant: 'success'
                }));
                this.name = '';
                this.description = '';
                this.email = '';
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error'
                }));
            });
    }
}