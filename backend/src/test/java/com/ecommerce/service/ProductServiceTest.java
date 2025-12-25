package com.ecommerce.service;

import com.ecommerce.dto.ProductDTO;
import com.ecommerce.entity.Product;
import com.ecommerce.repository.ProductRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * ProductService 单元测试
 */
@ExtendWith(MockitoExtension.class)
public class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private ProductService productService;

    private Product testProduct;

    @BeforeEach
    public void setUp() {
        testProduct = new Product();
        testProduct.setId(1L);
        testProduct.setName("测试商品");
        testProduct.setDescription("测试描述");
        testProduct.setPrice(new BigDecimal("99.99"));
        testProduct.setStock(100);
        testProduct.setCategory("测试分类");
    }

    @Test
    public void testGetAllProducts() {
        // 准备测试数据
        Product product2 = new Product();
        product2.setId(2L);
        product2.setName("测试商品2");
        product2.setPrice(new BigDecimal("199.99"));
        product2.setStock(50);

        List<Product> products = Arrays.asList(testProduct, product2);

        // Mock 仓储层
        when(productRepository.findAll()).thenReturn(products);

        // 执行测试
        List<ProductDTO> result = productService.getAllProducts();

        // 验证结果
        assertNotNull(result);
        assertEquals(2, result.size());
        assertEquals("测试商品", result.get(0).getName());
        assertEquals("测试商品2", result.get(1).getName());
        verify(productRepository, times(1)).findAll();
    }

    @Test
    public void testGetProductById() {
        // Mock 仓储层
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));

        // 执行测试
        ProductDTO result = productService.getProductById(1L);

        // 验证结果
        assertNotNull(result);
        assertEquals("测试商品", result.getName());
        assertEquals(new BigDecimal("99.99"), result.getPrice());
        verify(productRepository, times(1)).findById(1L);
    }

    @Test
    public void testGetProductByIdNotFound() {
        // Mock 仓储层
        when(productRepository.findById(999L)).thenReturn(Optional.empty());

        // 执行测试并验证异常
        assertThrows(RuntimeException.class, () -> {
            productService.getProductById(999L);
        });
        verify(productRepository, times(1)).findById(999L);
    }

    @Test
    public void testCreateProduct() {
        // 准备测试数据
        ProductDTO productDTO = new ProductDTO();
        productDTO.setName("新商品");
        productDTO.setPrice(new BigDecimal("299.99"));
        productDTO.setStock(200);

        // Mock 仓储层
        when(productRepository.save(any(Product.class))).thenReturn(testProduct);

        // 执行测试
        ProductDTO result = productService.createProduct(productDTO);

        // 验证结果
        assertNotNull(result);
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    public void testUpdateProduct() {
        // 准备测试数据
        ProductDTO productDTO = new ProductDTO();
        productDTO.setName("更新商品");
        productDTO.setPrice(new BigDecimal("399.99"));
        productDTO.setStock(150);

        // Mock 仓储层
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));
        when(productRepository.save(any(Product.class))).thenReturn(testProduct);

        // 执行测试
        ProductDTO result = productService.updateProduct(1L, productDTO);

        // 验证结果
        assertNotNull(result);
        verify(productRepository, times(1)).findById(1L);
        verify(productRepository, times(1)).save(any(Product.class));
    }

    @Test
    public void testDeleteProduct() {
        // Mock 仓储层
        when(productRepository.existsById(1L)).thenReturn(true);
        doNothing().when(productRepository).deleteById(1L);

        // 执行测试
        productService.deleteProduct(1L);

        // 验证结果
        verify(productRepository, times(1)).existsById(1L);
        verify(productRepository, times(1)).deleteById(1L);
    }

    @Test
    public void testDeleteProductNotFound() {
        // Mock 仓储层
        when(productRepository.existsById(999L)).thenReturn(false);

        // 执行测试并验证异常
        assertThrows(RuntimeException.class, () -> {
            productService.deleteProduct(999L);
        });
        verify(productRepository, times(1)).existsById(999L);
        verify(productRepository, never()).deleteById(999L);
    }
}
