import styles from '../styles/Home.module.css'
import { ethers } from "ethers";
import React, { useState } from "react";
import Link from 'next/link';
//let provider = new ethers.providers.Web3Provider(window.ethereum);
//let signer = provider.getSigner();
import Navbar from '../src/components/navbar';

export default function Buy() {

    const contractAddress = ""
    const abi = ""

    const BuyBond = async() => {
        try {
			//await window.ethereum.request({ method: "eth_requestAccounts" });
			// const provider = new ethers.providers.Web3Provider(window.ethereum);
			//const signer = provider.getSigner();

			//const contract = new ethers.Contract(contractAddress, abi, signer);

			//const transaction = await contract.____(0, {
			//	value: ethers.utils.parseEther(inAmount)
			//});

			//const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      //setwalletAddress(accounts[0]);
			//await transaction.wait();

			//setChange(true);
			//setinAmount("");

			// const info =  web3.eth.getTransactionReceipt(tx.result);           
			// console.log(info);
		} catch (error) {
			alert('Please key in a valid amount of ETH')
		}
	};
    

    return (
      <>
      <Navbar/>
    
        <div className={styles.container}>

        <main className={styles.main}>
          <h1 className={styles.title}>
            Buy Bonds
          </h1>

          <div className = {styles.card}>
            <h3>
              <Link href="./">Back to home</Link>
            </h3>
          </div>
  
          <div className={styles.grid}>
            <a className={styles.card}>
              <div className = {styles.inline}>
                <h2>Bond 1</h2>
              </div>
              <div className = {styles.inline}>
                <input 
                className = {styles.input}
                type="number"
                placeholder="Enter Amount"
                />
              </div>
            </a>

            <button 
            className = {styles.button}
            onClick={()=> {BuyBond()}}
            >Buy Bond 1</button>
  

            <a className={styles.card}>
              <div className = {styles.inline}>
                <h2>Bond 2</h2>
              </div>
              <div className = {styles.inline}>
                <input 
                className = {styles.input}
                type="number"
                placeholder="Enter Amount"
                />
              </div>  
            </a>
            <button 
            className = {styles.button}
            onClick={()=> {BuyBond()}}
            >Buy Bond 2</button>
  
            
          </div>
        </main>
        
      </div>
      </>
    )
}
