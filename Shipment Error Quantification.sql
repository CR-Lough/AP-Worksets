--A system error occurred where chargebacks were the combination of separate vendors' 
--shipments. Normally one vendor per shipment, just how many shipments have multiple 
--vendors' items on the same chargeback?   


--CTE to record how many different vendors were combined into one shipment charge
--for a specific day. There should only be one vendor identifier per shipment.
WITH num_occurence as
  (
	SELECT 
		ext_shipment_num, 
		count(distinct ext_vendor_num) as vendor_count, 
		count(distinct extract(day from created_date)) as date_count  
    FROM vendor_attr
		JOIN shipment_header
			ON vendor_attr.supplier = shipment_header.supplier
		JOIN  shipment_detail   
			ON shipment_detail.int_shipment_num = shipment_header.int_shipment_num
    WHERE shipment_header.created_date between '01-OCT-2020' and current_date
    GROUP BY ext_shipment_num
  )
 
--For each different vendor number, list out the header level shipment details
SELECT
  vendor_attr.ext_vendor_num as vendor_number,
  shipment_header.supplier,
  shipment_header.int_shipment_num,
  shipment_header.ext_shipment_num,
  shipment_header.store,
  shipment_detail.reason,
  shipment_header.created_date,
  shipment_header.ret_auth_num,
  sum(shipment_detail.unit_cost*shipment_detail.qty_returned) as ttl_cost,
  sum(shipment_detail.qty_returned) as ttl_units

FROM vendor_attr 
  JOIN shipment_header
    ON vendor_attr.supplier = shipment_header.supplier
  JOIN shipment_detail   
    ON shipment_detail.int_shipment_num = shipment_header.int_shipment_num
  JOIN num_occurence
    ON num_occurence.ext_shipment_num = shipment_header.ext_shipment_num
    
WHERE shipment_header.created_date between '01-OCT-2020' and '01-NOV-2020'

GROUP BY 
  vendor_attr.ext_vendor_num,
  shipment_header.supplier,
  shipment_header.int_shipment_num, 
  shipment_header.ext_shipment_num,
  shipment_header.store,
  shipment_detail.reason, 
  shipment_header.created_date, 
  shipment_header.ret_auth_num
  
--Only retrieve the shipments that have 2 different vendor numbers 
--on the same date 
HAVING vendor_count in ('2') 
AND valid_date_count in ('1');
