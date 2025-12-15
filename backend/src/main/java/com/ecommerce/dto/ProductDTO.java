package com.ecommerce.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

/**
 * 商品数据传输对象
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductDTO {
    
    private Long id;
    
    @NotBlank(message = "商品名称不能为空")
    @Size(max = 255, message = "商品名称长度不能超过255")
    private String name;
    
    @Size(max = 2000, message = "商品描述长度不能超过2000")
    private String description;
    
    @NotNull(message = "商品价格不能为空")
    @DecimalMin(value = "0.01", message = "商品价格必须大于0")
    private BigDecimal price;
    
    @NotNull(message = "库存数量不能为空")
    @Min(value = 0, message = "库存数量不能为负数")
    private Integer stock;
    
    @Size(max = 100, message = "分类长度不能超过100")
    private String category;
    
    @Size(max = 500, message = "图片URL长度不能超过500")
    private String imageUrl;
}
