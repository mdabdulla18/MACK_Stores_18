import { LightningElement, track } from 'lwc';

export default class DiscountCalculator extends LightningElement {
    @track amount = 0;
    @track discount = 0;

    get finalPrice() {
        let discountValue = (this.amount * this.discount) / 100;
        return this.amount - discountValue;
    }

    handleAmountChange(event) {
        this.amount = parseFloat(event.target.value) || 0;
    }

    handleDiscountChange(event) {
        this.discount = parseFloat(event.target.value) || 0;
    }
}