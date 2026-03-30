<?php
include_once('includes/connect.php');
include_once('functions/common_function.php');
session_start();

$get_ip_add = getIPAddress();

if (isset($_POST['update_cart']) && isset($_POST['quantity']) && is_array($_POST['quantity'])) {
    foreach ($_POST['quantity'] as $product_id => $qty) {
        $product_id = (int)$product_id;
        $qty = (int)$qty;
        if ($qty < 1) {
            $qty = 1;
        }
        $update_qty = "UPDATE `card_details` SET quantity=$qty WHERE ip_address='$get_ip_add' AND product_id=$product_id";
        mysqli_query($con, $update_qty);
    }
    echo "<script>alert('Cart updated successfully')</script>";
    echo "<script>window.open('cart.php','_self')</script>";
}

if (isset($_POST['remove_cart'])) {
    if (isset($_POST['remove_item']) && is_array($_POST['remove_item'])) {
        foreach ($_POST['remove_item'] as $remove_id) {
            $remove_id = (int)$remove_id;
            $delete_query = "DELETE FROM `card_details` WHERE ip_address='$get_ip_add' AND product_id=$remove_id";
            mysqli_query($con, $delete_query);
        }
        echo "<script>alert('Selected item(s) removed from cart')</script>";
    }
    echo "<script>window.open('cart.php','_self')</script>";
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.1/css/all.min.css" integrity="sha512-5Hs3dF2AEPkpNAR7UiOHba+lRSJNeM2ECkwxUIxC1Q/FLycGTbNapWXB4tP889k5T5Ju8fs4b1P5z/iB4nMfSQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="stylesheet" href="./css/style.css">
    <title>Cart</title>
</head>

<body>
    <div class="container-fluid p-0">
        <nav class="navbar navbar-expand-lg navbar-light bg-info">
            <div class="container-fluid">
                <img src="./images/logo.png" alt="" class="logo">
                <a class="navbar-brand" href="#">Logo</a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                        <li class="nav-item"><a class="nav-link active" href="index.php">Home</a></li>
                        <li class="nav-item"><a class="nav-link" href="display_all.php">Products</a></li>
                        <li class="nav-item"><a class="nav-link" href="./users_area/user_registration.php">Register</a></li>
                        <li class="nav-item"><a class="nav-link" href="cart.php">Cart <sup><?php cart_item(); ?></sup></a></li>
                        <li class="nav-item"><a class="nav-link" href="#">Total Price: <?php total_cart_price(); ?>/-</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <nav class="navbar navbar-expand-lg navbar-dark bg-secondary">
            <ul class="navbar-nav me-auto">
                <?php
                if (!isset($_SESSION['username'])) {
                    echo "<li class='nav-item'><a class='nav-link' href='#'>Welcome Guest</a></li>";
                    echo "<li class='nav-item'><a class='nav-link' href='./users_area/user_login.php'>Login</a></li>";
                } else {
                    echo "<li class='nav-item'><a class='nav-link' href='#'>Welcome " . $_SESSION['username'] . "</a></li>";
                    echo "<li class='nav-item'><a class='nav-link' href='./users_area/logout.php'>Logout</a></li>";
                }
                ?>
            </ul>
        </nav>

        <div class="bg-light p-3 text-center">
            <h3>Shopping Cart</h3>
            <p>Review your items, update quantity, then proceed to checkout.</p>
        </div>

        <div class="container my-4">
            <form action="" method="post">
                <table class="table table-bordered text-center">
                    <thead class="bg-info">
                        <tr>
                            <th>Product</th>
                            <th>Image</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Remove</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        $grand_total = 0;
                        $cart_query = "SELECT * FROM `card_details` WHERE ip_address='$get_ip_add'";
                        $result_query = mysqli_query($con, $cart_query);

                        if ($result_query && mysqli_num_rows($result_query) > 0) {
                            while ($row = mysqli_fetch_assoc($result_query)) {
                                $product_id = (int)$row['product_id'];
                                $qty = (int)$row['quantity'];
                                if ($qty < 1) {
                                    $qty = 1;
                                }

                                $select_products = "SELECT * FROM `products` WHERE product_id=$product_id";
                                $result_products = mysqli_query($con, $select_products);

                                if ($result_products && mysqli_num_rows($result_products) > 0) {
                                    $product = mysqli_fetch_assoc($result_products);
                                    $title = $product['product_title'];
                                    $image = $product['product_image1'];
                                    $price = (float)$product['product_price'];
                                    $line_total = $price * $qty;
                                    $grand_total += $line_total;

                                    echo "<tr>
                                            <td>$title</td>
                                            <td><img src='./admin_area/product_images/$image' alt='$title' style='width:70px;height:70px;object-fit:cover;'></td>
                                            <td>$price/-</td>
                                            <td><input type='number' min='1' name='quantity[$product_id]' value='$qty' class='form-control'></td>
                                            <td>$line_total/-</td>
                                            <td><input type='checkbox' name='remove_item[]' value='$product_id'></td>
                                          </tr>";
                                }
                            }
                        } else {
                            echo "<tr><td colspan='6' class='text-danger'>Your cart is empty.</td></tr>";
                        }
                        ?>
                    </tbody>
                </table>

                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <h5 class="mb-0">Grand Total: <?php echo $grand_total; ?>/-</h5>
                    <div>
                        <a href="index.php" class="btn btn-secondary">Continue Shopping</a>
                        <input type="submit" name="update_cart" value="Update Cart" class="btn btn-info">
                        <input type="submit" name="remove_cart" value="Remove Selected" class="btn btn-danger">
                        <a href="./users_area/checkout.php" class="btn btn-success">Checkout</a>
                    </div>
                </div>
            </form>
        </div>

        <?php include('./includes/footer.php'); ?>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
</body>

</html>
