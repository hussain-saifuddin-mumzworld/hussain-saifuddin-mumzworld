SELECT 
    FORMAT_DATE('%B', postShippingInfo_shipped_first) AS Month,
    CONCAT(
        fc_loc, " - ",
        CASE 
            WHEN dropoff_country = "AE" THEN "UAE"
            WHEN dropoff_country = "SA" THEN "KSA"
            ELSE "ROGCC" 
        END
    ) AS LANE,
    deliverytype,
    COUNT(distinct partnerShipmentReference) AS All_Shipments,
    COUNT(distinct IF(Latest_status = "delivered", partnerShipmentReference, NULL)) AS Delivered_Shipments,
    COUNT(distinct IF(Latest_status IN ("returned", "return_in_transit", "return_confirmed", "ready_for_return", "cancelled_by_carrier", "cancelled", "missing"), partnerShipmentReference, NULL)) AS Returned_Shipments,
    COUNT(distinct IF(Latest_status NOT IN ("delivered", "returned", "return_in_transit", "return_confirmed", "ready_for_return", "cancelled_by_carrier", "cancelled", "missing"), partnerShipmentReference, NULL)) AS Pending_Shipments
FROM 
    `mumzdriver.Wimo.carriyo_shipments`
WHERE 
    entityType = "FORWARD"
    AND Latest_status NOT IN ("error")
    AND DATE(postShippingInfo_shipped_first) >= '2024-01-01'
    AND DATE(postShippingInfo_shipped_first) <= CURRENT_DATE()
GROUP BY 
    1, 2, 3
ORDER BY 
    1, 2;
