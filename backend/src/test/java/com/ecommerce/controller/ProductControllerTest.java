package com.ecommerce.controller;

import com.ecommerce.dto.ProductDTO;
import com.ecommerce.service.ProductService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.ResponseEntity;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * ProductController 单元测试
 */
@ExtendWith(MockitoExtension.class)
public class ProductControllerTest {

    @Mock
    private ProductService productService;

    @InjectMocks
    private ProductController productController;

    @Test
    public void testGetAllProducts() {
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
        ResponseEntity<Map<String, Object>> response = productController.getAllProducts();

        // 验证结果
        assertNotNull(response);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertTrue((Boolean) response.getBody().get("success"));
        assertEquals(2, response.getBody().get("total"));
        verify(productService, times(1)).getAllProducts();
    }

    @Test
    public void testGetProductById() {
        // 准备测试数据
        ProductDTO product = new ProductDTO();
        product.setId(1L);
        product.setName("测试商品");
        product.setPrice(new BigDecimal("99.99"));
        product.setStock(100);

        // Mock 服务层
        when(productService.getProductById(1L)).thenReturn(product);

        // 执行测试
        ResponseEntity<Map<String, Object>> response = productController.getProductById(1L);

        // 验证结果
        assertNotNull(response);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertTrue((Boolean) response.getBody().get("success"));
        verify(productService, times(1)).getProductById(1L);
    }

    @Test
    public void testCreateProduct() {
        // 准备测试数据
        ProductDTO inputProduct = new ProductDTO();
        inputProduct.setName("新商品");
        inputProduct.setPrice(new BigDecimal("299.99"));
        inputProduct.setStock(200);

        ProductDTO savedProduct = new ProductDTO();
        savedProduct.setId(1L);
        savedProduct.setName("新商品");
        savedProduct.setPrice(new BigDecimal("299.99"));
        savedProduct.setStock(200);

        // Mock 服务层
        when(productService.createProduct(any(ProductDTO.class))).thenReturn(savedProduct);

        // 执行测试
        ResponseEntity<Map<String, Object>> response = productController.createProduct(inputProduct);

        // 验证结果
        assertNotNull(response);
        assertEquals(201, response.getStatusCodeValue());  // 创建资源返回 201
        assertNotNull(response.getBody());
        assertTrue((Boolean) response.getBody().get("success"));
        verify(productService, times(1)).createProduct(any(ProductDTO.class));
    }

    @Test
    public void testUpdateProduct() {
        // 准备测试数据
        ProductDTO inputProduct = new ProductDTO();
        inputProduct.setName("更新商品");
        inputProduct.setPrice(new BigDecimal("399.99"));
        inputProduct.setStock(150);

        ProductDTO updatedProduct = new ProductDTO();
        updatedProduct.setId(1L);
        updatedProduct.setName("更新商品");
        updatedProduct.setPrice(new BigDecimal("399.99"));
        updatedProduct.setStock(150);

        // Mock 服务层
        when(productService.updateProduct(eq(1L), any(ProductDTO.class))).thenReturn(updatedProduct);

        // 执行测试
        ResponseEntity<Map<String, Object>> response = productController.updateProduct(1L, inputProduct);

        // 验证结果
        assertNotNull(response);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertTrue((Boolean) response.getBody().get("success"));
        verify(productService, times(1)).updateProduct(eq(1L), any(ProductDTO.class));
    }

    @Test
    public void testDeleteProduct() {
        // Mock 服务层
        doNothing().when(productService).deleteProduct(1L);

        // 执行测试
        ResponseEntity<Map<String, Object>> response = productController.deleteProduct(1L);

        // 验证结果
        assertNotNull(response);
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertTrue((Boolean) response.getBody().get("success"));
        verify(productService, times(1)).deleteProduct(1L);
    }
}
