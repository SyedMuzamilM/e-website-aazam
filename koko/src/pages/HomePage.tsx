import React, { useEffect, useState } from "react";
import { ProductCard } from "../components/ProductCard";
import { Product } from "../lib/types";

interface AppProps {}

export const HomePage: React.FC<AppProps> = (props) => {
  const [products, setProducts] = useState<Product[]>([]);

  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch("http://localhost:4000/api/v1/products");
      const data = await response.json();

      setProducts(data.data);
    };

    fetchData();
  }, []);

  return (
    <>
      <div className={`flex flex-col justify-center items-center`}>
        <h1 className={`text-red-800 text-bold font-serif text-5xl`}>
          Products
        </h1>
        <div
          className={`flex flex-wrap justify-center lg:w-9/12 sm:w-9/12`}
        >
            {products.map((p: Product) => {
              return (
                  <ProductCard product={p} key={p.id}/>
              );
            })}
        </div>
      </div>
    </>
  );
};
