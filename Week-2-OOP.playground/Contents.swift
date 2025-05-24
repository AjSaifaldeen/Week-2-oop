import Foundation

// MARK: - Exercise 1: Social Media Post Class
print("🌟 === EXERCISE 1: SOCIAL MEDIA POST === 🌟\n")

class Post {
    let author: String
    let content: String
    var likes: Int
    
    init(author: String, content: String, likes: Int = 0) {
        self.author = author
        self.content = content
        self.likes = likes
    }
    
    func display() {
        print("📱 Social Media Post")
        print("👤 Author: \(author)")
        print("💬 Content: \(content)")
        print("❤️ Likes: \(likes)")
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}

// Creating two Post objects with different content and authors
let post1 = Post(
    author: "Alice Johnson",
    content: "Just finished an amazing hike in the mountains! The view was breathtaking 🏔️",
    likes: 42
)

let post2 = Post(
    author: "Bob Smith",
    content: "Excited to share my new Swift app with everyone! Download it now 📱",
    likes: 128
)

// Display both posts
print("First Post:")
post1.display()
print("\nSecond Post:")
post2.display()


// MARK: - Exercise 2: Shopping Cart with Singleton Pattern
print("🛒 === EXERCISE 2: SHOPPING CART SINGLETON === 🛒\n")

class Product {
    let name: String
    let price: Double
    var quantity: Int
    
    init(name: String, price: Double, quantity: Int = 1) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
    
    func getTotalPrice() -> Double {
        return price * Double(quantity)
    }
}

class ShoppingCartSingleton {
    // Singleton instance
    static let sharedInstance = ShoppingCartSingleton()
    
    // Private initializer to prevent external instantiation
    private init() {}
    
    // Internal collection to store products
    private var products: [Product] = []
    
    // Add product to cart
    func addProduct(product: Product, quantity: Int) {
        // Check if product already exists in cart
        if let existingProductIndex = products.firstIndex(where: { $0.name == product.name }) {
            // Update quantity if product exists
            products[existingProductIndex].quantity += quantity
            print("✅ Updated \(product.name) quantity to \(products[existingProductIndex].quantity)")
        } else {
            // Add new product with specified quantity
            let newProduct = Product(name: product.name, price: product.price, quantity: quantity)
            products.append(newProduct)
            print("✅ Added \(quantity) x \(product.name) to cart")
        }
    }
    
    // Remove product from cart
    func removeProduct(product: Product) {
        if let index = products.firstIndex(where: { $0.name == product.name }) {
            let removedProduct = products.remove(at: index)
            print("🗑️ Removed \(removedProduct.name) from cart")
        } else {
            print("❌ Product \(product.name) not found in cart")
        }
    }
    
    // Clear entire cart
    func clearCart() {
        products.removeAll()
        print("🧹 Cart cleared - all products removed")
    }
    
    // Calculate total price of all items
    func getTotalPrice() -> Double {
        return products.reduce(0) { total, product in
            total + product.getTotalPrice()
        }
    }
    
    // Display cart contents
    func displayCart() {
        print("\n🛒 Shopping Cart Contents:")
        if products.isEmpty {
            print("   Cart is empty")
        } else {
            for product in products {
                print("   • \(product.quantity) x \(product.name) - $\(product.price) each = $\(product.getTotalPrice())")
            }
            print("   💰 Total: $\(String(format: "%.2f", getTotalPrice()))")
        }
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    }
}

// Testing the Shopping Cart Singleton
let cart = ShoppingCartSingleton.sharedInstance

// Create some products
let laptop = Product(name: "MacBook Pro", price: 2499.99, quantity: 1)
let mouse = Product(name: "Magic Mouse", price: 79.99, quantity: 1)
let keyboard = Product(name: "Magic Keyboard", price: 199.99, quantity: 1)
let headphones = Product(name: "AirPods Pro", price: 249.99, quantity: 1)

// Test adding products
cart.addProduct(product: laptop, quantity: 1)
cart.addProduct(product: mouse, quantity: 2)
cart.addProduct(product: keyboard, quantity: 1)
cart.displayCart()

// Test adding same product again (should update quantity)
cart.addProduct(product: mouse, quantity: 1)
cart.displayCart()

// Test removing a product
cart.removeProduct(product: keyboard)
cart.displayCart()

// Test that singleton works (same instance)
let anotherCartReference = ShoppingCartSingleton.sharedInstance
anotherCartReference.addProduct(product: headphones, quantity: 1)
print("\n🔍 Proving Singleton Pattern:")
print("Both references point to same instance: \(cart === anotherCartReference)")
cart.displayCart()

// Test clearing cart
cart.clearCart()
cart.displayCart()



// MARK: - Exercise 3: Payment Processor with Error Handling
print("💳 === EXERCISE 3: PAYMENT SYSTEM === 💳\n")

// Custom error type for payment errors
enum PaymentError: Error {
    case insufficientFunds(required: Double, available: Double)
    case invalidCard(reason: String)
    case networkError(message: String)
    case invalidAmount(amount: Double)
    
    var localizedDescription: String {
        switch self {
        case .insufficientFunds(let required, let available):
            return "Insufficient funds: Required $\(required), Available $\(available)"
        case .invalidCard(let reason):
            return "Invalid card: \(reason)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .invalidAmount(let amount):
            return "Invalid amount: $\(amount)"
        }
    }
}

// Payment processor protocol
protocol PaymentProcessor {
    func processPayment(amount: Double) throws
}

// Credit Card Processor implementation
class CreditCardProcessor: PaymentProcessor {
    private let cardNumber: String
    private let availableCredit: Double
    
    init(cardNumber: String, availableCredit: Double) {
        self.cardNumber = cardNumber
        self.availableCredit = availableCredit
    }
    
    func processPayment(amount: Double) throws {
        // Validate amount
        guard amount > 0 else {
            throw PaymentError.invalidAmount(amount: amount)
        }
        
        // Simulate card validation
        guard cardNumber.count == 16 else {
            throw PaymentError.invalidCard(reason: "Card number must be 16 digits")
        }
        
        // Check if sufficient credit available
        guard availableCredit >= amount else {
            throw PaymentError.insufficientFunds(required: amount, available: availableCredit)
        }
        
        // Simulate network processing delay
        if Int.random(in: 1...10) == 1 { // 10% chance of network error
            throw PaymentError.networkError(message: "Connection timeout")
        }
        
        print("💳 Credit Card Payment Successful!")
        print("   Amount: $\(String(format: "%.2f", amount))")
        print("   Card: ****-****-****-\(String(cardNumber.suffix(4)))")
    }
}

// Cash Processor implementation
class CashProcessor: PaymentProcessor {
    private var cashAvailable: Double
    
    init(cashAvailable: Double) {
        self.cashAvailable = cashAvailable
    }
    
    func processPayment(amount: Double) throws {
        // Validate amount
        guard amount > 0 else {
            throw PaymentError.invalidAmount(amount: amount)
        }
        
        // Check if sufficient cash available
        guard cashAvailable >= amount else {
            throw PaymentError.insufficientFunds(required: amount, available: cashAvailable)
        }
        
        // Process cash payment
        cashAvailable -= amount
        print("💵 Cash Payment Successful!")
        print("   Amount: $\(String(format: "%.2f", amount))")
        print("   Remaining Cash: $\(String(format: "%.2f", cashAvailable))")
    }
}

// Testing Payment Processing with Error Handling
print("Testing Payment Processors:\n")

// Create payment processors
let creditCard = CreditCardProcessor(cardNumber: "1234567890123456", availableCredit: 1000.00)
let cash = CashProcessor(cashAvailable: 500.00)

let paymentAmounts = [150.00, 750.00, 1200.00, -50.00]
let processors: [PaymentProcessor] = [creditCard, cash]
let processorNames = ["Credit Card", "Cash"]

for (index, processor) in processors.enumerated() {
    print("🔄 Testing \(processorNames[index]) Processor:")
    
    for amount in paymentAmounts {
        do {
            print("\n💰 Processing payment of $\(String(format: "%.2f", amount))...")
            try processor.processPayment(amount: amount)
            print("✅ Payment processed successfully!")
            
        } catch let error as PaymentError {
            print("❌ Payment failed: \(error.localizedDescription)")
            
        } catch {
            print("❌ Unexpected error: \(error)")
        }
    }
    
 }

// Additional testing with invalid card
print("\n🧪 Testing Invalid Credit Card:")
let invalidCard = CreditCardProcessor(cardNumber: "123", availableCredit: 1000.00)

do {
    try invalidCard.processPayment(amount: 100.00)
} catch let error as PaymentError {
    print("❌ Expected error caught: \(error.localizedDescription)")
}

print("\n🎉 All exercises completed successfully! 🎉")
