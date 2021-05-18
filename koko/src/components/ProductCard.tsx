import { Link } from "react-router-dom";
import { Product } from "../lib/types";


export const ProductCard = ({product}: any) => {
    return (
        <Link to={`/product/${product.pr_slug}?id=${product.id}`}>

        <div className={`flex flex-col bg-green-200 px-4 py-2 my-2 mx-2  rounded-md `}>
            <img src="https://via.placeholder.com/300.png/09f/fff" alt="Demo" />
            <h1 className={`font-serif text-2xl`}>
                {product.pr_name}
            </h1>
            {product.discount_price !== null ? (

            <p className={`font-bold`}>Rs: {product.sales_price - product.discount_price}
                <span className={`text-gray-400 line-through`}>{product.sales_price}</span>
            </p>
            )
            : <p className={`text-right`}>Rs: {product.sales_price}</p>
            }
            <span>{product.category}</span>
        </div>
        </Link>
    );
}
