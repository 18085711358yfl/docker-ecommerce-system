package com.ecommerce;

import com.ecommerce.dto.ProductDTO;
import com.ecommerce.entity.Product;
import com.ecommerce.repository.ProductRepository;
import com.ecommerce.service.ProductService;
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
 * 商品服务单元测试
 */
@ExtendWith(MockitoExtension.class)
class ProductServiceTest {
    
    @Mock
    private ProductRepository productRepository;
    
    @InjectMocks
    private ProductService productService;
    
    private Product testProduct;
    
    @BeforeEach
    void setUp() {
        testProduct = new Product();
        testProduct.setId(1L);
        testProduct.setName("测试商品");
        testProduct.setDescription("测试描述");
        testProduct.setPrice(new BigDecimal("99.99"));
        testProduct.setStock(100);
        testProduct.setCategory("测试分类");
    }
    
    @Test
    void testGetAllProducts() {
        // Given
        when(productRepository.findAll()).thenReturn(Arrays.asList(testProduct));
        
        // When
        List<ProductDTO> products = productService.getAllProducts();
        
        // Then
        assertNotNull(products);
        assertEquals(1, products.size());
        assertEquals("测试商品", products.get(0).getName());
        verify(productRepository, times(1)).findAll();
    }
    
    @Test
    void testGetProductById() {
        // Given
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));
        
        // When
        ProductDTO product = productService.getProductById(1L);
        
        // Then
        assertNotNull(product);
        assertEquals("测试商品", product.getName());
        assertEquals(new BigDecimal("99.99"), product.getPrice());
        verify(productRepository, times(1)).findById(1L);
    }
    
    @Test
    void testCreateProduct() {
        // Given
        ProductDTO productDTO = new ProductDTO();
        productDTO.setName("新商品");
        productDTO.setPrice(new BigDecimal("199.99"));
        productDTO.setStock(50);
        
        when(productRepository.save(any(Product.class))).thenReturn(testProduct);
        
        // When
        ProductDTO createdProduct = productService.createProduct(productDTO);
        
        // Then
        assertNotNull(createdProduct);
        verify(productRepository, times(1)).save(any(Product.class));
    }
    
    @Test
    void testUpdateProduct() {
        // Given
        ProductDTO productDTO = new ProductDTO();
        productDTO.setName("更新商品");
        productDTO.setPrice(new BigDecimal("299.99"));
        productDTO.setStock(75);
        
        when(productRepository.findById(1L)).thenReturn(Optional.of(testProduct));
        when(productRepository.save(any(Product.class))).thenReturn(testProduct);
        
        // When
        ProductDTO updatedProduct = productService.updateProduct(1L, productDTO);
        
        // Then
        assertNotNull(updatedProduct);
        verify(productRepository, times(1)).findById(1L);
        verify(productRepository, times(1)).save(any(Product.class));
    }
    
    @Test
    void testDeleteProduct() {
        // Given
        when(productRepository.existsById(1L)).thenReturn(true);
        doNothing().when(productRepository).deleteById(1L);
        
        // When
        productService.deleteProduct(1L);
        
        // Then
        verify(productRepository, times(1)).existsById(1L);
        verify(productRepository, times(1)).deleteById(1L);
    }
    
    @Test
    void testGetProductByIdNotFound() {
        // Given
        when(productRepository.findById(999L)).thenReturn(Optional.empty());
        
        // When & Then
        assertThrows(RuntimeException.class, () -> {
            productService.getProductById(999L);
        });
    }
}
