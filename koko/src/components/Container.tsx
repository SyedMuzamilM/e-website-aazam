interface ContainerProps {
}

export const Container: React.FC<ContainerProps> = ({children}) => {
    return(
        <div className={`flex justify-center items-center`}>
            <div className={`flex justify-start lg:w-8/12 sm:w-10/12 mx-4 w-full`}>
            {children}
            </div>
        </div>
    )
}