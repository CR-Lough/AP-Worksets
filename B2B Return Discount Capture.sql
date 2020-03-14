# Necessary selection fields
#
select
	return_header.vendor,
	return_header.ext_ref_no,
	return_dtl.reason,
	return_header.created_date,
	system.sku.dept,
	sum(return_dtl.unit_cost*return_dtl.qty_returned) as dept_ttl_cost,
	system.terms.percent,
	return_header.ret_auth_num
#	
# Information was very spread out, follow proper inner join syntax and checked
# for NULL values as well as  potenitally eliminated return shipments   
# 
from return_header
  join  return_dtl   
    on return_dtl.rtv_order_no = return_header.rtv_order_no
  join  system.sku
    on system.sku.sku = return_dtl.sku
  join vendor_terms
    on  vendor_terms.dept = system.sku.dept
  join system.terms
    on system.terms.terms = vendor_terms.terms
#
#  
where vendor_terms.vendor = return_header.vendor 
	and return_header.created_date between '01-JAN-2020' and '31-JAN-2020'
	and return_header.vendor in('553655131','123456','78945612',..........)
	and length(ext_ref_no) < 7 
	and length(ext_ref_no) > 5 
	and system.terms.percent <> 0
#
#   
group by return_header.vendor, 
	return_header.ext_ref_no, 
	return_dtl.reason, 
	return_header.created_date, 
	system.sku.dept, 
	system.terms.percent, 
	return_header.ret_auth_num