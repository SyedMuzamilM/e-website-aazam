import { useEffect, useState } from "react";

export const useFetch = (url: string) => {
  const [data, setData] = useState<any>();
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetch(url)
      .then((res) => {
        setLoading(true);
        res.json();
      })
      .then((data) => {
        setLoading(false);
        setData(data);
      });
  }, [url]);

  return { data, loading };
};
