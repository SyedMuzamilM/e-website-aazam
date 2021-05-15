import { useEffect, useState } from "react";
import { useQuery } from "../hooks/useQuery";
import { Product } from "../lib/types";

export const ProductPage: React.FC = () => {
  const query = useQuery();
  const [product, setProduct] = useState<Product>();

  useEffect(() => {
    const fethProduct = async () => {
      const responce = await fetch(
        `http://localhost:4000/api/v1/products/${query.get("id")}`
      );
      const data = await responce.json();

      setProduct(data.data);
    };

    fethProduct();
  }, []);
  return (
    <div className={`flex sm:flex-row flex-col justify-center content-center my-5 mx-4`}>
      {product !== undefined ? (
        <div className={`flex sm:flex-row flex-col justify-between sm:w-9/12 w-full`}>
          <div className={`flex justify-center sm:w-4/12 w-full  sm:mx-4 bg-green-200`}>
            <img
              src="https://via.placeholder.com/300.png/09f/fff"
              alt={product.pr_name}
            />
          </div>
          <div className={`flex flex-col justify-start px-4 py-6 sm:w-6/12 w-full sm:mx-4`}>
            <h1 className={`sm:text-3xl text-2xl font-serif font-bold`}>
              {product.pr_name}
            </h1>
            {product.discount_price !== null ? (
              <div className={`mt-3`}>
                <p>
                  M.R.P:
                  <span className={`line-through mx-2 text-gray-500`}>
                    &#8377;{product.sales_price}
                  </span>
                </p>
                <p className={`flex items-start`}>
                  {" "}
                  Price:{" "}
                  <span className={`text-blue-500 text-xl mx-2`}>
                    {" "}
                    &#8377;{product.sales_price - product.discount_price}
                  </span>
                </p>
                <p>You Save:  
                  <span className={`text-blue-500 text-xl mx-1`}>
                    {" "}
                    &#8377;{product.discount_price} ({((product?.discount_price / product?.sales_price) * 100).toFixed(2)} %)
                  </span>
                 </p>
              </div>
            ) : (
              <p className={`flex items-start`}>
                {" "}
                Price:{" "}
                <span className={`text-blue-500 text-xl mx-2`}>
                  {" "}
                  &#8377;{product.sales_price}
                </span>
              </p>
            )}
          </div>
          <div className={`sm:w-3/12 sm:mx-4 w-full sm:px-4 px-3  sm:py-6 py-4 bg-green-700`}>
              <h2 className={`text-2xl text-white font-semibold`}>Add to cart</h2>
          </div>
        </div>
      ) : (
        <h1>No Product Found</h1>
      )}
    </div>
  );
};
