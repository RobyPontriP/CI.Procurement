using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace myTree.WebForms.Procurement.General
{
    public class DataModel
    {
        public class Autorhize
        {
            public Boolean access { get; set; }
            public Boolean admin { get; set; }
        }

        public class Workflow
        {
            public string sn { get; set; }
            public string action { get; set; }
            public string comment { get; set; }
            public string comment_file { get; set; }
            public string activity_id { get; set; }
            public string roles { get; set; }
            public string current_status { get; set; }
            public string is_direct_to_finance { get; set; }
            public string purchasing_process { get; set; }
            public string purchase_type { get; set; }
            public string amount { get; set; }
            public string access_token { get; set; }
            public Boolean IsProcOffChangedDuringResubmit { get; set; }
        }

        public class LatestActivity
        {
            public string activity_id { get; set; }
            public string action { get; set; }
        }

        public class Lifecycle
        {
            public string module_name { get; set; }
            public string module_id { get; set; }
            public string module_code { get; set; }
            public string status_id { get; set; }
            public string updated_by { get; set; }
        }

        public class Comment
        {
            public string id { get; set; }
            public string module_name { get; set; }
            public string module_id { get; set; }
            public string emp_user_id { get; set; }
            public string roles { get; set; }
            public string created_date { get; set; }
            public string action_taken { get; set; }
            public string comment { get; set; }
            public string comment_file { get; set; }
            public string approval_no { get; set; }
            public string activity_id { get; set; }
        }

        public class DeletedId
        {
            public string id { get; set; }
            public string table { get; set; }
        }

        public class Attachment
        {
            public string id { get; set; }
            public string filename { get; set; }
            public string file_description { get; set; }
            public string document_type { get; set; }
            public string document_id { get; set; }
            public string is_active { get; set; }
            public string approval_no { get; set; }
            public string is_provide_file { get; set; }
            public string change_time { get; set; }
        }

        public class Category
        {
            public string id { get; set; }
            public string name { get; set; }
            public string is_active { get; set; }
            public string initial { get; set; }

            public virtual List<SubCategory> SubCategories { get; set; }
        }

        public class SubCategory
        {
            public string id { get; set; }
            public string category { get; set; }
            public string name { get; set; }
            public string is_active { get; set; }
            public string initial { get; set; }

            public string can_edit { get; set; }
        }

        public class Brand
        {
            public string id { get; set; }
            public string name { get; set; }
            public string is_active { get; set; }
            public virtual List<BrandCategory> BrandCategories { get; set; }
        }

        public class BrandCategory
        {
            public string id { get; set; }
            public string brand { get; set; }
            public string category { get; set; }
            public string subcategory { get; set; }
            public string is_active { get; set; }

            public string category_name { get; set; }
            public string subcategory_name { get; set; }
        }

        public class Select2
        {
            public string id { get; set; }
            public string text { get; set; }
            public string condition { get; set; }
        }

        public class Item
        {
            public string id { get; set; }
            public string category { get; set; }
            public string subcategory { get; set; }
            public string brand { get; set; }
            public string description { get; set; }
            public string uom { get; set; }
            public string item_code { get; set; }
            public string sun_code { get; set; }
            public string sun_description { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }
            public string is_item_active { get; set; }

            public string sun_lookup_code { get; set; }
            public string sun_short_desc { get; set; }
            public string sun_long_desc { get; set; }
            public string sun_status { get; set; }
            public string sun_item_group { get; set; }
            public string sun_account_code { get; set; }
            public string category_name { get; set; }
            public string subcategory_name { get; set; }
            public string brand_name { get; set; }
            public string uom_name { get; set; }
            public string item_active_label { get; set; }

            public virtual List<Attachment> attachments { get; set; }
        }

        public class Vendor
        {
            public string id { get; set; }
            public string company_code { get; set; }
            public string sun_code { get; set; }
            public string lookup_code { get; set; }
            public string sun_status { get; set; }
            public string short_desc { get; set; }
            public string company_name { get; set; }
            public string description { get; set; }
            public string telp_no { get; set; }
            public string fax_no { get; set; }
            public string email { get; set; }
            public string mobile_no { get; set; }
            public string website { get; set; }
            public string account_code { get; set; }
            public string payment_method { get; set; }
            public string business_type { get; set; }
            public string qualification { get; set; }
            public string tax_opt1 { get; set; }
            public string tax_opt2 { get; set; }
            public string is_payment_address_same { get; set; }
            public string is_order_address_same { get; set; }
            public string is_vendor_active { get; set; }

            public string remarks { get; set; }
            public string is_active { get; set; }
            public string ocs_supplier_code { get; set; }

            public string sun_status_name { get; set; }
            public string payment_method_name { get; set; }
            public string business_type_name { get; set; }
            public string qualification_name { get; set; }
            public string tax_opt1_name { get; set; }
            public string tax_opt2_name { get; set; }
            public string vendor_active_label { get; set; }
            public string tax_system { get; set; }
            public string tax_system_name { get; set; }

            //public virtual ListVendorAddress main_address { get; set; }
            public virtual VendorAddress payment_address { get; set; }
            public virtual VendorAddress order_address { get; set; }

            public virtual List<VendorAddress> main_address { get; set; }
            public virtual List<VendorCategory> categories { get; set; }
            public virtual List<VendorContactPerson> contacts { get; set; }
            public virtual List<Attachment> attachments { get; set; }
        }

        public class VendorAddress
        {
            public string id { get; set; }
            public string vendor_id { get; set; }
            public string address_type { get; set; }
            public string sun_address_code { get; set; }
            public string address1 { get; set; }
            public string address2 { get; set; }
            public string address3 { get; set; }
            public string address4 { get; set; }
            public string address5 { get; set; }
            public string city { get; set; }
            public string state { get; set; }
            public string postal_code { get; set; }
            public string country_id { get; set; }
            public string country_name { get; set; }
            public string is_active { get; set; }
            public string is_on_sun { get; set; }
            public string vendor_address_active_label { get; set; }

            //new
            public string address_name { get; set; }
            public string url { get; set; }



        }

        public class VendorCategory
        {
            public string id { get; set; }
            public string vendor_id { get; set; }
            public string category { get; set; }
            public string subcategory { get; set; }
            public string is_active { get; set; }

            public string category_name { get; set; }
            public string subcategory_name { get; set; }

            public string can_edit { get; set; }
        }

        public class VendorContactPerson
        {
            public string id { get; set; }
            public string vendor_id { get; set; }
            public string salutation { get; set; }
            public string first_name { get; set; }
            public string last_name { get; set; }
            public string name { get; set; }
            public string position { get; set; }
            public string cell_phone { get; set; }
            public string work_phone { get; set; }
            public string fax { get; set; }
            public string email { get; set; }
            public string is_active { get; set; }

            public string vendor_address_id { get; set; }
            public string cc_email { get; set; }
            public string mobile_phone { get; set; }
            public string home_phone { get; set; }

            public string vendor_cp_active_label { get; set; }
        }

        public class PurchaseRequisition
        {
            public string id { get; set; }
            public string pr_no { get; set; }
            public string requester { get; set; }
            public string required_date { get; set; }
            public string cifor_office_id { get; set; }
            public string cost_center_id { get; set; }
            public string cost_center_id_name { get; set; }
            public string t4 { get; set; }
            public string remarks { get; set; }
            public string submission_date { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string total_estimated { get; set; }
            public string total_estimated_usd { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string requester_name { get; set; }
            public string cifor_office_name { get; set; }
            public string t4_name { get; set; }
            public string exchange_sign_format { get; set; }
            public string is_direct_to_finance { get; set; }
            public string direct_to_finance_justification { get; set; }
            public string direct_to_finance_file { get; set; }
            public string purchase_type { get; set; }
            public string purchase_type_description { get; set; }
            public string other_purchase_type { get; set; }
            public string purchasing_process { get; set; }

            public string is_revision { get; set; }

            public string journal_no { get; set; }
            public string reference_no { get; set; }
            public string is_payment { get; set; }

            public string is_procurement { get; set; }
            public string temporary_id { get; set; }
            public bool is_trigger_audit { get; set; }
            public string pr_type { get; set; }
            public string id_submission_page_type { get; set; }
            public string submission_page_name { get; set; }

            public virtual List<Attachment> attachments_general { get; set; }
            public virtual List<PurchaseRequisitionDetail> details { get; set; }
            public virtual List<JournalNo> journalno { get; set; }
        }

        public class PurchaseRequisitionDetail
        {
            public string id { get; set; }
            public string pr_id { get; set; }
            public string line_no { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string category { get; set; }
            public string subcategory { get; set; }
            public string brand { get; set; }
            public string description { get; set; }
            public string request_qty { get; set; }
            public string uom { get; set; }
            public string unit_price { get; set; }
            public string unit_price_usd { get; set; }
            public string estimated_cost { get; set; }
            public string estimated_cost_usd { get; set; }
            public string open_qty { get; set; }
            public string is_direct_purchase { get; set; }
            public string last_price_currency { get; set; }
            public string last_price_amount { get; set; }
            public string last_price_quantity { get; set; }
            public string last_price_uom { get; set; }
            public string last_price_date { get; set; }
            public string purpose { get; set; }
            public string delivery_address { get; set; }
            public string is_other_address { get; set; }
            public string other_delivery_address { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_sign_format { get; set; }
            public string exchange_rate { get; set; }

            public string category_name { get; set; }
            public string subcategory_name { get; set; }
            public string brand_name { get; set; }
            public string uom_name { get; set; }

            public string actions { get; set; }
            public string status_name { get; set; }
            public string closing_remarks { get; set; }
            public string item_description { get; set; }
            public bool is_trigger_audit { get; set; }

            public DirectPurchase directPurchase { get; set; }

            public virtual List<Attachment> attachments { get; set; }
            public virtual List<PurchaseRequisitionDetailCostCenter> costCenters { get; set; }
        }

        public class PurchaseRequisitionDetailCostCenter
        {
            public string id { get; set; }
            public string pr_id { get; set; }
            public string pr_detail_id { get; set; }
            public string sequence_no { get; set; }
            public string cost_center_id { get; set; }
            public string work_order { get; set; }
            public string entity_id { get; set; }
            public string legal_entity { get; set; }
            public string control_account { get; set; }
            public string percentage { get; set; }
            public string amount { get; set; }
            public string amount_usd { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }

            public string cost_center_name { get; set; }
            public string work_order_name { get; set; }
            public string entity_name { get; set; }
            public bool is_trigger_audit { get; set; }
        }

        public class DirectPurchase
        {
            public string id { get; set; }
            public string pr_line_id { get; set; }
            public string item_id { get; set; }
            public string vendor_id { get; set; }
            public string vendor_address_id { get; set; }
            public string purchase_currency { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string unit_price { get; set; }
            public string total_cost { get; set; }
            public string total_cost_usd { get; set; }
            public string purchase_date { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string created_by { get; set; }

            public string exchange_sign_format { get; set; }
            public string pr_id { get; set; }
            public string pr_no { get; set; }
            public string pr_currency { get; set; }
            public string pr_unit_price { get; set; }
            public string pr_total_cost { get; set; }
            public string pr_total_cost_usd { get; set; }
            public string pr_exchange_sign { get; set; }
            public string pr_exchange_rate { get; set; }
            public string item_code { get; set; }
            public string brand_name { get; set; }
            public string description { get; set; }
            public string purchase_qty { get; set; }
            public string vendor_name { get; set; }
            public string direct_purchase_qty { get; set; }

            public string actions { get; set; }
            public string temporary_id { get; set; }

            public virtual List<Attachment> attachments { get; set; }
            public virtual List<SundrySupplier> sundry { get; set; }
        }

        public class ApprovalNotes
        {
            public string activity_name { get; set; }
            public string activity_desc { get; set; }
        }

        public class RequestForQuotation
        {
            public string id { get; set; }
            public string rfq_no { get; set; }
            public string session_no { get; set; }
            public string document_date { get; set; }
            public string due_date { get; set; }
            public string send_date { get; set; }
            public string remarks { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string vendor_contact_person { get; set; }
            public string method { get; set; }
            public string template { get; set; }
            public string copy_from_id { get; set; }
            public string cifor_office_id { get; set; }
            public string cifor_office { get; set; }
            public string is_active { get; set; }
            public string status_id { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string last_updated_by { get; set; }
            public string last_updated_date { get; set; }
            public string series { get; set; }

            public string vendor_code { get; set; }
            public string vendor_address { get; set; }
            public string vendor_contact_person_name { get; set; }
            public string vendor_contact_person_email { get; set; }
            public string status_name { get; set; }
            public string legal_entity { get; set; }
            public string legal_entity_name { get; set; }
            public string procurement_office_address_id { get; set; }
            public string procurement_office_address { get; set; }

            public virtual List<RequestForQuotationDetail> details { get; set; }
            public virtual List<SundrySupplier> sundry { get; set; }
        }

        public class RequestForQuotationDetail
        {
            public string id { get; set; }
            public string rfq_id { get; set; }
            public string line_number { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string brand_name { get; set; }
            public string description { get; set; }
            public string request_quantity { get; set; }
            public string uom { get; set; }
            public string status_id { get; set; }
            public string pr_detail_id { get; set; }
            public string pr_id { get; set; }
            public string pr_no { get; set; }
            public string is_active { get; set; }
            public virtual List<RequestForQuotationDetailCostCenter> costCenters { get; set; }
        }

        public class RequestForQuotationDetailCostCenter
        {
            public string id { get; set; }
            public string rfq_id { get; set; }
            public string rfq_detail_id { get; set; }
            public string pr_detail_cost_center_id { get; set; }
            public string sequence_no { get; set; }
            public string cost_center_id { get; set; }
            public string work_order { get; set; }
            public string entity_id { get; set; }
            public string legal_entity { get; set; }
            public string control_account { get; set; }
            public string percentage { get; set; }
            public string amount { get; set; }
            public string amount_usd { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }

            public string cost_center_name { get; set; }
            public string work_order_name { get; set; }
            public string entity_name { get; set; }
        }

        public class Quotation
        {
            public string id { get; set; }
            public string q_no { get; set; }
            public string cifor_office_id { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string vendor_code { get; set; }
            public string vendor_document_no { get; set; }
            public string vendor_address_id { get; set; }
            public string receive_date { get; set; }
            public string document_date { get; set; }
            public string due_date { get; set; }
            public string payment_terms { get; set; }
            public string payment_terms_name { get; set; }
            public string is_other_payment_terms { get; set; }
            public string other_payment_terms { get; set; }
            public string remarks { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string discount_type { get; set; }
            public string discount { get; set; }
            public string discount_currency { get; set; }
            public string total_discount { get; set; }
            public string quotation_amount { get; set; }
            public string quotation_amount_usd { get; set; }
            public string rfq_id { get; set; }
            public string rfq_no { get; set; }
            public string copy_from_id { get; set; }
            public string is_active { get; set; }
            public string status_id { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string last_updated_by { get; set; }
            public string last_updated_date { get; set; }
            public string reff_rfq_no { get; set; }

            public string source { get; set; }
            public string status_name { get; set; }
            public string exchange_sign_format { get; set; }
            public string temporary_id { get; set; }

            public virtual List<QuotationDetail> details { get; set; }
            public virtual List<Attachment> attachments { get; set; }
            public virtual List<SundrySupplier> sundry { get; set; }
        }

        public class QuotationDetail
        {
            public string id { get; set; }
            public string quotation { get; set; }
            public string line_number { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string brand_name { get; set; }
            public string description { get; set; }
            public string uom_id { get; set; }
            public string uom { get; set; }
            public string quantity { get; set; }
            public string quotation_quantity { get; set; }
            public string quotation_description { get; set; }
            public string unit_price { get; set; }
            public string discount_type { get; set; }
            public string discount { get; set; }
            public string discount_amount { get; set; }
            public string additional_discount { get; set; }
            public string line_total { get; set; }
            public string line_total_usd { get; set; }

            public string indent_time { get; set; }
            public string warranty { get; set; }
            public string remarks { get; set; }
            public string rfq_detail_id { get; set; }
            public string rfq_id { get; set; }
            public string rfq_no { get; set; }
            public string pr_detail_id { get; set; }
            public string pr_id { get; set; }
            public string pr_no { get; set; }
            public string source_quantity { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string close_quantity { get; set; }
            public string close_remarks { get; set; }

            public string rfq_quantity { get; set; }
            public string pr_quantity { get; set; }
            public string pr_currency { get; set; }
            public string pr_unit_price { get; set; }
            public string pr_estimated_cost { get; set; }
            public string vs_quantity { get; set; }

            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }

            public string total_discount { get; set; }
            public string total_discount_usd { get; set; }
        }

        public class QuotationDetailCostCenter
        {
            public string id { get; set; }
            public string quotation { get; set; }
            public string quotation_detail_id { get; set; }
            public string pr_detail_cost_center_id { get; set; }
            public string rfq_detail_cost_center_id { get; set; }
            public string sequence_no { get; set; }
            public string cost_center_id { get; set; }
            public string work_order { get; set; }
            public string entity_id { get; set; }
            public string legal_entity { get; set; }
            public string control_account { get; set; }
            public string percentage { get; set; }
            public string amount { get; set; }
            public string amount_usd { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }

            public string cost_center_name { get; set; }
            public string work_order_name { get; set; }
            public string entity_name { get; set; }
        }

        public class VendorSelection
        {
            public string id { get; set; }
            public string vs_no { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string cifor_office_id { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string last_updated_by { get; set; }
            public string last_updated_date { get; set; }
            public string document_date { get; set; }

            public string status_name { get; set; }

            public string singlesourcing { get; set; }

            public string justification_singlesourcing { get; set; }

            public string justification_file_singlesourcing { get; set; }

            public string ss_initiated_by { get; set; }

            public string is_submission { get; set; }
            public string ss_guideline { get; set; }

            public virtual List<VendorSelectionDetail> details { get; set; }
            public virtual List<Attachment> attachments { get; set; }
            public virtual List<SundrySupplier> sundry { get; set; }
        }

        public class VendorSelectionDetail
        {
            public string id { get; set; }
            public string vendor_selection { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string vendor_code { get; set; }
            public string vendor_contact_person { get; set; }
            public string q_id { get; set; }
            public string quotation_detail_id { get; set; }
            public string pr_detail_id { get; set; }
            public string source_quantity { get; set; }
            public string uom_id { get; set; }
            public string uom { get; set; }
            public string unit_price { get; set; }
            public string quantity { get; set; }
            public string discount { get; set; }
            public string line_total { get; set; }
            public string line_total_usd { get; set; }
            public string indent_time { get; set; }
            public string warranty_time { get; set; }
            public string expected_delivery_date { get; set; }
            public string reason_for_selection { get; set; }
            public string remarks { get; set; }
            public string justification_file { get; set; }
            public string is_selected { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string line_no { get; set; }
            public string pr_id { get; set; }
            public string pr_no { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string additional_discount { get; set; }

            public string max_quantity { get; set; }
            public string is_sundry { get; set; }
            public virtual List<VendorSelectionDetailCostCenter> detail_chargecode { get; set; } //detail cost center
        }

        public class VendorSelectionDetailCostCenter
        {
            public string id { get; set; }
            public string vendor_selection_id { get; set; }
            public string vendor_selection_detail_id { get; set; }
            public string pr_detail_cost_center_id { get; set; }
            public string quotation_detail_cost_center_id { get; set; }
            public string sequence_no { get; set; }
            public string cost_center_id { get; set; }
            public string work_order { get; set; }
            public string entity_id { get; set; }
            public string legal_entity { get; set; }
            public string control_account { get; set; }
            public string percentage { get; set; }
            public string amount { get; set; }
            public string amount_usd { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }
        }

        public class PurchaseOrder
        {


            public string id { get; set; }
            public string po_no { get; set; }
            public string po_sun_code { get; set; }
            public string creator_sun_code { get; set; }
            public string cifor_office_id { get; set; }
            public string document_date { get; set; }
            public string vendor { get; set; }
            public string vendor_name { get; set; }
            public string vendor_code { get; set; }
            public string vendor_contact_person { get; set; }
            public string vendor_contact_person_name { get; set; }
            public string vendor_contact_person_to_email { get; set; }
            public string remarks { get; set; }
            public string send_date { get; set; }
            public string expected_delivery_date { get; set; }
            public string po_type { get; set; }
            public string sun_trans_type { get; set; }
            public string po_prefix { get; set; }
            public string cifor_shipment_account { get; set; }
            public string cifor_shipment_account_name { get; set; }
            public string cifor_delivery_address { get; set; }
            public string cifor_delivery_full_address { get; set; }
            public string delivery_term { get; set; }
            public string delivery_term_name { get; set; }
            public string invoice_delivery_address { get; set; }
            public string procurement_address { get; set; }
            public string procurement_address_name { get; set; }
            public string organization_name { get; set; }
            public string term_of_payment { get; set; }
            public string term_of_payment_name { get; set; }
            public string other_term_of_payment { get; set; }
            public string is_other_term_of_payment { get; set; }
            public string legal_entity { get; set; }
            public string account_code { get; set; }
            public string period { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string gross_amount { get; set; }
            public string gross_amount_usd { get; set; }
            public string discount { get; set; }
            public string tax { get; set; }
            public string tax_type { get; set; }
            public string total_amount { get; set; }
            public string total_amount_usd { get; set; }
            public string is_active { get; set; }
            public string status_id { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string last_updated_by { get; set; }
            public string last_updated_date { get; set; }
            public string is_notification_sent_to_user { get; set; }
            public string is_other_address { get; set; }
            public string other_address { get; set; }

            public string status_name { get; set; }
            public string vendor_address { get; set; }
            public string vendor_telp_no { get; set; }
            public string vendor_fax_no { get; set; }
            public string delivery_telp { get; set; }
            public string delivery_fax { get; set; }
            public string order_reference { get; set; }
            public string tax_amount { get; set; }
            public string accountant { get; set; }
            public string total_after_discount { get; set; }
            public string is_sundry { get; set; }
            public string is_sundry_po { get; set; }
            public string payable_vat { get; set; }
            public string IsMyTreeSupplier { get; set; }

            public string ocs_supplier_id { get; set; }
            public string ocs_supplier_code { get; set; }
            public string ocs_supplier_name { get; set; }
            public string is_print;

            public string detail_sundry { get; set; }
            public string contact_description { get; set; }
            public string is_goods { get; set; }

            public virtual List<PurchaseOrderDetail> details { get; set; }
            public virtual List<PurchaseOrderDetailCostCenter> detailsCC { get; set; }
        }

        public class PurchaseOrderDetail
        {
            public string id { get; set; }
            public string purchase_order { get; set; }
            public string line_number { get; set; }
            public string item_id { get; set; }
            public string item_code { get; set; }
            public string brand_name { get; set; }
            public string description { get; set; }
            public string quotation_description { get; set; }
            public string uom { get; set; }
            public string pr_detail_cost_center_id { get; set; }
            public string pr_detail_id { get; set; }
            public string pr_id { get; set; }
            public string pr_no { get; set; }
            public string rfq_id { get; set; }
            public string rfq_no { get; set; }
            public string q_id { get; set; }
            public string q_no { get; set; }
            public string vs_detail_id { get; set; }
            public string vs_cost_centers_detail_id { get; set; }
            public string vs_id { get; set; }
            public string vs_no { get; set; }
            public string cost_center_id { get; set; }
            public string work_order { get; set; }
            public string quantity { get; set; }
            public string unit_price { get; set; }
            public string discount { get; set; }
            public string additional_discount { get; set; }
            public string line_total { get; set; }
            public string line_total_usd { get; set; }
            public string currency_id { get; set; }
            public string exchange_sign { get; set; }
            public string exchange_rate { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }
            public string status_id { get; set; }
            public string vat_payable { get; set; }
            public string vat_printable { get; set; }
            public string vat_amount { get; set; }
            public string vat { get; set; }
            public string vat_type { get; set; }
            public virtual List<PurchaseOrderDetailCostCenter> costCenters { get; set; }
        }

        public class PurchaseOrderDetailCostCenter
        {
            public string id { get; set; }
            public string purchase_order { get; set; }
            public string purchase_order_detail_id { get; set; }
            public string vendor_selection_detail_id { get; set; }
            public string vendor_selection_detail_cost_center_id { get; set; }
            public string pr_detail_cost_center_id { get; set; }
            public string sequence_no { get; set; }
            public string cost_center_id { get; set; }
            public string work_order { get; set; }
            public string entity_id { get; set; }
            public string legal_entity { get; set; }
            public string control_account { get; set; }
            public string percentage { get; set; }
            public string amount { get; set; }
            public string amount_usd { get; set; }
            public string amount_usd_vat { get; set; }
            public string amount_vat { get; set; }
            public string amount_vat_product { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }

            public string cost_center_name { get; set; }
            public string work_order_name { get; set; }
            public string entity_name { get; set; }
        }

        public class UserConfirmation
        {
            public string id { get; set; }
            public string confirmation_code { get; set; }
            public string document_no { get; set; }
            public string send_date { get; set; }
            public string confirm_date { get; set; }
            public string status_id { get; set; }
            public string is_active { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string last_updated_by { get; set; }
            public string last_updated_date { get; set; }

            public virtual List<UserConfirmationDetail> details { get; set; }
            public virtual List<Attachment> documents { get; set; }
        }

        public class UserConfirmationDetail
        {
            public string id { get; set; }
            public string user_confirmation { get; set; }
            public string base_type { get; set; }
            public string base_id { get; set; }
            public string send_quantity { get; set; }
            public string status_id { get; set; }
            public string quantity { get; set; }
            public string quality { get; set; }
            public string additional_person { get; set; }
            public string is_notification_sent { get; set; }
            public string user_id { get; set; }
        }

        public class ItemClosure
        {
            public string id { get; set; }
            public string temporary_id { get; set; }
            public string reason_for_closing { get; set; }
            public string reason_for_closing_name { get; set; }
            public string base_type { get; set; }
            public string base_id { get; set; }
            public string pr_detail_id { get; set; }
            public string grm_no { get; set; }
            public string grm_line { get; set; }
            public string close_date { get; set; }
            public string quantity { get; set; }
            public string actual_amount { get; set; }
            public string actual_amount_usd { get; set; }
            public string remarks { get; set; }
            public string is_active { get; set; }
            public string created_by { get; set; }
            public string created_date { get; set; }
            public string last_updated_by { get; set; }
            public string last_updated_date { get; set; }

            public string po_code { get; set; }
            public string pr_code { get; set; }
            public string item_code { get; set; }
            public string item_description { get; set; }
            public string po_quantity { get; set; }
            public string uom { get; set; }
            public string actual_vendor { get; set; }
            public string actual_date { get; set; }
            public string estimated_cost { get; set; }
            public string estimated_cost_usd { get; set; }
            public string po_cost { get; set; }
            public string po_cost_usd { get; set; }
            public string po_currency_id { get; set; }
            public string pr_currency_id { get; set; }
            public string unit_price { get; set; }
            public string confirm_date { get; set; }
            public string remaining_quantity { get; set; }

            public virtual List<Attachment> attachments { get; set; }
        }

        public class payment
        {
            public string id { get; set; }
            public string journal_no { get; set; }
            public string is_payment { get; set; }
        }

        public class JournalNo
        {
            public string id { get; set; }
            public string pr_id { get; set; }
            public string journal_no { get; set; }
            public string journal_attachment { get; set; }
            public string journal_attachment_id { get; set; }
            public string journal_attachment_description { get; set; }
            public string is_active { get; set; }
        }

        public class SundrySupplier
        {
            public string id { get; set; }
            public string sundry_supplier_id { get; set; }
            public string module_id { get; set; }
            public string module_type { get; set; }
            public string name { get; set; }
            public string address { get; set; }
            public string contact_person { get; set; }
            public string email { get; set; }
            public string phone_number { get; set; }
            public string bank_account { get; set; }
            public string swift { get; set; }
            public string sort_code { get; set; }
            public string place { get; set; }
            public string province { get; set; }
            public string post_code { get; set; }
            public string vat_reg_no { get; set; }
            public string module_detail_id { get; set; }
        }

    }
}
