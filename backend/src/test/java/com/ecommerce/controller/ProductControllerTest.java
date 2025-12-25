package com.ecommerce.controller;

import com.ecommerce.dto.ProductDTO;
import com.ecommerce.service.ProductService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * ProductController 单元测试
 */
@WebMvcTest(ProductController.class)
public class ProductControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ProductService productService;

    @Test
    public void testGetAllProducts() throws Exception {
        // 准备测试数据
        ProductDTO product1 = new ProductDTO();
        product1.setId(1L);
        product1.setName("测试商品1");
        product1.setPrice(new BigDecimal("99.99"));
        product1.setStock(100);

        ProductDTO product2 = new ProductDTO();
        product2.setId(2L);
        product2.setName("测试商品2");
        product2.setPrice(new BigDecimal("199.99"));
        product2.setStock(50);

        List<ProductDTO> products = Arrays.asList(product1, product2);

        // Mock 服务层
        when(productService.getAllProducts()).thenReturn(products);

        // 执行测试
        mockMvc.perform(get("/api/products")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].name").value("测试商品1"))
                .andExpect(jsonPath("$[1].name").value("测试商品2"));
    }

    @Test
    public void testGetProductById() throws Exception {
        // 准备测试数据
        ProductDTO product = new ProductDTO();
        product.setId(1L);
        product.setName("测试商品");
        product.setPrice(new BigDecimal("99.99"));
        product.setStock(100);

        // Mock 服务层
        when(productService.getProductById(1L)).thenReturn(product);

        // 执行测试
        mockMvc.perform(get("/api/products/1")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("测试商品"))
                .andExpect(jsonPath("$.price").value(99.99));
    }

    @Test
    public void testCreateProduct() throws Exception {
        // 准备测试数据
        ProductDTO product = new ProductDTO();
        product.setId(1L);
        product.setName("新商品");
        product.setPrice(new BigDecimal("299.99"));
        product.setStock(200);

        // Mock 服务层
        when(productService.createProduct(any(ProductDTO.class))).thenReturn(product);

        // 执行测试
        String productJson = "{\"name\":\"新商品\",\"price\":299.99,\"stock\":200}";

        mockMvc.perform(post("/api/products")
                .contentType(MediaType.APPLICATION_JSON)
                .content(productJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("新商品"));
    }

    @Test
    public void testUpdateProduct() throws Exception {
        // 准备测试数据
        ProductDTO product = new ProductDTO();
        product.setId(1L);
        product.setName("更新商品");
        product.setPrice(new BigDecimal("399.99"));
        product.setStock(150);

        // Mock 服务层
        when(productService.updateProduct(any(Long.class), any(ProductDTO.class))).thenReturn(product);

        // 执行测试
        String productJson = "{\"name\":\"更新商品\",\"price\":399.99,\"stock\":150}";

        mockMvc.perform(put("/api/products/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(productJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.name").value("更新商品"));
    }

    @Test
    public void testDeleteProduct() throws Exception {
        // 执行测试
        mockMvc.perform(delete("/api/products/1")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
}
